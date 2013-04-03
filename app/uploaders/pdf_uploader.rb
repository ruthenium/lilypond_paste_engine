# encoding: utf-8

class PdfUploader < PasteBaseUploader

  def extension_white_list
    %w(pdf)
  end

end
