class Paste < ActiveRecord::Base
  attr_accessible :hold, :lilypond_text, :mxml
  attr_readonly :visible_id

  has_many :images, :dependent => :destroy
  
  mount_uploader :mxml, MxmlUploader
  mount_uploader :lilypond, LilypondUploader
  mount_uploader :pdf, PdfUploader

  before_create :set_defaults
  # after_create :start_processing
  #after_destroy :remove_uploads_dir

  #validates_integrity_of :mxml

  validates_each :mxml, :lilypond_text, :on => :create, :allow_nil => true, :allow_blank => true do
    |record, attr_name, value|
    m = (attr_name == :mxml) ? :size : :bytesize
    record.errors.add(attr_name,
      'The size of data submitted is over 2 megabytes') if value.send(m) > 2.megabytes
  end

  validate :on => :create do
    fields = [:mxml, :lilypond_text]
    break if fields.map {|f| errors.has_key? f}.any? #hack for carrierwave

    fields = fields.map {|f| send f} #[mxml, lilypond_text]
    if fields.all? &:blank?
      errors.add :base, 'At least one input field must be set'
    elsif fields.all? &:present?
      errors.add :base, 'Only one input field must be set'
    end
  end

  # scope :aadmin_mxml_not_null_in, lambda { |i|
  #   if i == [1]
  #     where('"pastes"."mxml" is NOT NULL')
  #   else
  #     where(:mxml => nil)
  #   end
  # } # hack for active admin. Maybe use custom widget?..
  # search_method :aadmin_mxml_not_null_in, :type => :integer

  def to_param
    persisted? ? visible_id : nil
  end

  def as_json(args=nil)
    case args
    when :links then
      {
        id:       visible_id,
        lilypond: lilypond.url,
        mxml:     mxml.url,
        pdf:      pdf.url,
        images:   images.map {|i| i.png.url }
      }
    when :status then
      {
        id:        visible_id,
        processed: processed?,
        success:   proc_success?
      }
    else
      super args
    end
  end

  def viewed!
    update_attribute(:expires_at, 30.days.since(Time.now)) if processed? && proc_success? && hold?
  end

  protected

  def set_defaults
    self.processed = false
    self.proc_success = false
    self.expires_at = 30.days.since Time.now

    begin
      self.visible_id = SecureRandom.hex(3)
    end while self.class.exists?(:visible_id => visible_id)
  end

end
