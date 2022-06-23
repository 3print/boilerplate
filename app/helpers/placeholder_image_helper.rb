require 'RMagick'
require 'rvg/rvg'

module PlaceholderImageHelper
  def placeholder_image_tag(*args)
    "<img src='#{placeholder_image_url(*args)}' />".html_safe
  end

  def placeholder_image_url(*args)
    "data:image/png;base64,#{placeholder_image_data(*args)}".html_safe
  end

  def placeholder_image_data(*args)
    if args.first.is_a? String
      width, height = args.shift.downcase.split('x').map(&:to_i)
    end

    options = args.shift || {}

    width ||= options[:width].to_i
    height ||= options[:height].to_i
    color = options.key?(:color) ? options[:color].to_s : "grey69"

    rvg = Magick::RVG.new(width, height).viewbox(0, 0, width, height) do |canvas|
      canvas.background_fill = color
      canvas.background_fill_opacity = 0
    end

    img = rvg.draw
    img.alpha(Magick::ActivateAlphaChannel)

    img.format = "png"

    [img.to_blob].pack("m")
  end
end
