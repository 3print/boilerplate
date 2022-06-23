module ImageHelper
  def lazy_image_tag(format, src, options={})
    dimensions = format.split('/').map(&:to_i)
    config = {src: src}
    config[:srcset] = options[:srcset] if options[:srcset].present?
    config[:usepicture] = options[:usepicture] if options[:usepicture].present?

    placeholder = placeholder_image_url width: dimensions[0], height: dimensions[1]

    image_tag placeholder, { data: { lazy: config.to_json } }
  end
end
