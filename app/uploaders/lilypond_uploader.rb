# encoding: utf-8

class LilypondUploader < PasteBaseUploader
  def extension_white_list
    %w(ly)
  end
end
