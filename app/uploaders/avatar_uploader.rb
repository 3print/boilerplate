class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include PublicUploader
  include CropFromRegions
  include Sprockets::Rails::Helper

  def store_dir
    "uploads/#{ENV['AWS_ENV'] || :development}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def default_url
    "/assets/" + [version_name, "default.png"].compact.join('_')
  end

  version :medium do
    process crop: :medium
    process resize_to_fill: [300, 300]
  end

  version :profile do
    process crop: :profile
    process resize_to_fill: [128, 128]
  end

  version :thumb do
    process crop: :thumb
    process resize_to_fill: [60, 60]
  end
end
