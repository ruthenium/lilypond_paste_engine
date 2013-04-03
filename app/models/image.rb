class Image < ActiveRecord::Base
  attr_accessible :paste_id, :png
  belongs_to :paste
  mount_uploader :png, PngUploader
  #validates_presence_of :paste_id
end
