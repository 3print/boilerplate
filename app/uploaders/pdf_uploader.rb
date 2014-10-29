class PdfUploader < CarrierWave::Uploader::Base
  include PublicUploader
  include Sprockets::Rails::Helper

  def extension_white_list
    %w(pdf doc docx xls xlsx rtf odf)
  end
end
