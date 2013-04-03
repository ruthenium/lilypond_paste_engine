class PasteJob < Struct.new(:paste_id)

  def before(job)
    @paste = Paste.find_by_id(paste_id)
  end

  def perform
    # paste doesn't exist or was processed unsuccessfully
    return if @paste.blank? || @paste.processed?

    say "Processing paste #{@paste.id}, visible id: #{@paste.visible_id}"

    # Basename for lilypond file
    ly_basename = if @paste.mxml.blank? && @paste.lilypond_text.present?
      # Lilypond text was submitted. Using unixtime as basename
      Time.now.to_i.to_s
    elsif @paste.mxml.present? && @paste.lilypond_text.blank?
      # Mxml was submitted. Trying to convert it to lilypond
      @paste.lilypond_text = LilyHelpers.mxml_to_lilypond(@paste.mxml).presence || ''
      
      # Convertation failed
      return (@status = "Can't convert mxml") unless @paste.lilypond_text.present?

      # Using mxml file basename as basename for lilypond
      File.basename(@paste.mxml.file.filename, '.*')
    end # ly_basename
    
    # The checks above were not passed, i.e. data supplied is invalid
    return (@status = "Invalid data supplied") if ly_basename.nil?

    # Save lilypond text as a file
    @paste.lilypond = CustomStringIO.new("#{ly_basename}.ly", @paste.lilypond_text)

    Dir.mktmpdir do |tmp_dir|
      # Generate previews of lilypond file
      files = LilyHelpers.process_lilypond(@paste.lilypond, ly_basename, tmp_dir)

      # Previews were not generated
      return (@status = "Can't generate previews") if files.nil?
      
      # Save pdf
      @paste.pdf = File.open(files[:pdf][0])
      # Save png
      files[:png].each { |i| @paste.images.create :png => File.open(i) }
    end
    # Everything is ok
    @status = "OK"
  end

  def success(job)
    return unless @paste

    @data = {processed:true, status:@status}
    if @status == "OK"
      @data[:proc_success] = true
      @data[:expires_at] = 30.days.since @paste.created_at
    else
      @data[:proc_success] = false
      @data[:expires_at] = 1.day.since @paste.created_at
    end

    say "Paste #{@paste.id}, visible id: #{@paste.visible_id} processed #{@data[:proc_success] ? 'successfully' : 'unsuccessfully'}, saving."
  end

  def error(job,e)
    say "An error #{e} occured while processing"
    return unless @paste    
    @data = {processed:true, proc_success:false, expires_at:(1.day.since @paste.created_at)}
  end

  def after(j)
    return unless @paste
    @paste.update_attributes @data, :validate => false, :without_protection => true
  end

  protected

  def say(*args)
    level, message = ((args.size == 2) ? [args[0], args[1..-1].join(" ")] : [:info, args[0]])
    Delayed::Worker.logger.send(level, message) if Delayed::Worker.logger
  end
end