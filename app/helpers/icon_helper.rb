Iconic.config do |i|
  i.set_default_icon 'circle-thin'

  i.set_icon :create, :plus
  i.set_icon :edit, :pencil
  i.set_icon :destroy, :times
  i.set_icon :masquerade, 'user-secret'
  i.set_icon :email, :envelope
  i.set_icon :sign_out, 'sign-out'
  i.set_icon :profile, :cog

  i.set_icon :dashboard, :dashboard
  i.set_icon :main_nav, :cogs

  i.set_icon User, :user
  i.set_icon BpTest, :cubes
end

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

  def icon_for(o)
    icon(icon_name_for(o))
  end

  def icon_name_for(o)
    Iconic.get_icon(o)
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
