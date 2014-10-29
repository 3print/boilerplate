module HtmlHelper
  def cc_html(options={}, &blk)
    cls = options.delete(:class)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7]> <html#{attrs} class='lt-ie9 lt-ie8 lt-ie7 #{cls}'> <![endif]-->",
      "<!--[if IE 7]> <html#{attrs} class='lt-ie9 lt-ie8 #{cls}'> <![endif]-->",
      "<!--[if IE 8]> <html#{attrs} class='lt-ie9 #{cls}'> <![endif]-->",
      "<!--[if IE 9]> <html#{attrs} class='ie9 #{cls}'> <![endif]-->",
      "<!--[if gt IE 9]><!--> <html#{attrs} class='#{cls}'> <!--<![endif]-->",
      capture_haml(&blk).strip.html_safe,
      "</html>"
    ].join("\n").html_safe
  end

  def h(str); Rack::Utils.escape_html(str); end
end
