class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include PublicUploader
  include Sprockets::Rails::Helper

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process crop: :thumb
    process resize_to_fit: [60, 60]
  end

  def resize_to_fill (*args)
    args = args[0].call if args[0].is_a?(Proc)

    gravity_key = :"#{mounted_as}_gravity"
    if self.model.respond_to?(gravity_key) && gravity = self.model.send(gravity_key)
      args[2] = "Magick::#{gravity.camelize}Gravity".constantize
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
