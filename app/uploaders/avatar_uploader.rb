class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include PublicUploader
  include Sprockets::Rails::Helper


  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
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

  def resize_to_fill (*args)
    args = args[0].call if args[0].is_a?(Proc)

    gravity_key = :"#{mounted_as}_gravity"
    if self.model.respond_to?(gravity_key) && gravity = self.model.send(gravity_key)
      args[2] = "Magick::#{gravity.sub("#{mounted_as}_", "").camelize}Gravity".constantize
    end

    super(*args)
  end

  def crop(version)
    regions_key = :"#{mounted_as}_regions"
    if model.respond_to?(regions_key) && model.send(regions_key)[version.to_s].present?
      manipulate! do |img|
        x, y, w, h = model.send(regions_key)[version.to_s]
        img.crop!(x, y, w, h)
      end
    end
  end
end
