module CropFromRegions
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
