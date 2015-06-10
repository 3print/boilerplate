
module WickedPdfHelper
  def wicked_pdf_stylesheet_link_tag(*sources)
    sources.collect { |source|
      "<style type='text/css'>#{Rails.application.assets.find_asset(source+".css")}</style>"
    }.join("\n").html_safe
  end

  def wicked_pdf_image_path(img, options={})
    asset = Rails.application.assets.find_asset(img)
    "file://#{asset.pathname.to_s}"
  end

  def wicked_pdf_image_tag(img, options={})
    asset = Rails.application.assets.find_asset(img)
    image_tag "file://#{asset.pathname.to_s}", options
  end

  def wicked_pdf_font_path(font, options={})
    asset = Rails.application.assets.find_asset(font)
    if options[:url]
      "#{Rails.application.config.action_mailer.asset_host}/assets/#{font}"
    else
      "file://#{asset.pathname.to_s}"
    end
  end

  def wicked_pdf_javascript_src_tag(jsfile, options={})
    asset = Rails.application.assets.find_asset(jsfile)
    javascript_include_tag "file://#{asset.pathname.to_s}", options
  end

  def wicked_pdf_javascript_include_tag(*sources)
    sources.collect{ |source| "<script type='text/javascript'>#{Rails.application.assets.find_asset(source+".js")}</script>" }.join("\n").html_safe
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
