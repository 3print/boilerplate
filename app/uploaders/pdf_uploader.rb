class PdfUploader < CarrierWave::Uploader::Base
  include PublicUploader
  include Sprockets::Rails::Helper

  def extension_whitelist
    %w(pdf doc docx xls xlsx rtf odf)
  end
end
