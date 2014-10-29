module IconHelper
  def icon(name, options={})
    if options[:class]
      options[:class] += ' ' + icon_class(name)
    else
      options[:class] = icon_class(name)
    end

    content_tag(:i, nil, options) + ' '
  end

  def icon_class(name)
    "fa fa-#{name}"
  end

  def text_and_icon(text, ico)
    s = ''
    s += content_tag(:span, text, class: 'text')
    s += icon(ico)
    s.html_safe
  end

  def icon_and_text(text, ico)
    s = ''
    s += icon(ico)
    s += content_tag(:span, text, class: 'text')
    s.html_safe
  end
end
