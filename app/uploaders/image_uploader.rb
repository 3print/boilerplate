class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include PublicUploader
  include CropFromRegions
  include ResizeWithGravity
  include Sprockets::Rails::Helper

  def store_dir
    "#{ENV['AWS_ENV']}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process crop: :thumb
    process resize_to_fit: [60, 60]
  end
end
