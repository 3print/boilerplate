
module WickedPdfHelper
  def find_asset(asset_name)
    if Rails.env.development?
      Rails.application.assets.find_asset(asset_name).filename
    else
      "#{Rails.application.assets_manifest.directory}/#{Rails.application.assets_manifest.assets[asset_name]}"
    end
  end

  def read_asset(asset_name)
    if Rails.env.development?
      Rails.application.assets.find_asset(asset_name)
    else
      File.read(find_asset asset_name)
    end
  end

  def wicked_pdf_stylesheet_link_tag(*sources)
    sources.collect { |source|
      "<style type='text/css'>#{read_asset source + ".css"}</style>"
    }.join("\n").html_safe
  end

  def wicked_pdf_image_base64(img)
    "data:#{img.content_type};base64,#{Rack::Utils.escape(Base64.encode64(img.file.read))}"
  end

  def wicked_pdf_image_path(img, options={})
    "file://#{find_asset img}"
  end

  def wicked_pdf_image_tag(img, options={})
    image_tag "file://#{find_asset img}", options
  end

  def wicked_pdf_font_path(font, options={})
    if options[:url]
      "#{Rails.application.config.action_mailer.asset_host}/assets/#{font}"
    else
      "file://#{find_asset font}"
    end
  end

  def wicked_pdf_javascript_src_tag(jsfile, options={})

    javascript_include_tag "file://#{find_asset jsfile}", options
  end

  def wicked_pdf_javascript_include_tag(*sources)
    sources.collect{ |source| "<script type='text/javascript'>#{read_asset source + ".js"}</script>" }.join("\n").html_safe
  end

  def pdf_stylesheet_link_tag(*sources)
    @format == :pdf ? wicked_pdf_stylesheet_link_tag(*sources) : stylesheet_link_tag(*sources)
  end

  def pdf_javascript_include_tag(*sources)
    @format == :pdf ? wicked_pdf_javascript_include_tag(*sources) : javascript_include_tag(*sources)
  end

  def pdf_image_tag(*sources)
    @format == :pdf ? wicked_pdf_image_tag(*sources) : image_tag(*sources)
  end

  def pdf_image_path(pth)
    @format == :pdf ? wicked_pdf_image_path(pth) : image_path(pth)
  end
end
