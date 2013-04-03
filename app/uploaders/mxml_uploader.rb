# encoding: utf-8

class MxmlUploader < PasteBaseUploader

  def extension_white_list
    %w(xml mxml musicxml)
  end

end
