class FakeS3Uploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include PublicUploader
  include Sprockets::Rails::Helper

  def initialize(file_name)
    cache_id = SecureRandom.uuid
    original_filename = file_name
    @mounted_as = 'fake-s3-uploads'
  end

  def store_dir
    "uploads/#{mounted_as}/#{original_filename}"
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end
end
