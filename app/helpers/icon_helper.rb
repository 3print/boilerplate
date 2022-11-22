Feather.config do |i|
  i.set_default_icon 'circle'

  i.set_icon :create, 'plus-square'
  i.set_icon :edit, :edit
  i.set_icon :destroy, :trash
  i.set_icon :email, :mail
  i.set_icon :sign_out, 'log-out'
  i.set_icon :sign_in, 'log-in'
  i.set_icon :profile, :settings
  i.set_icon :pdf, :download
  i.set_icon :address, 'map-pin'
  i.set_icon :phone, :phone
  i.set_icon :more, 'more-horizontal'

  i.set_icon :dashboard, :sliders
  i.set_icon :resources, :database

  i.set_icon User, :users
  i.set_icon BpTest, :package # BOILERPLATE_ONLY
  i.set_icon StaticContent, 'file-text'
end

module IconHelper
  def icon(name)
    Feather[name]
  end

  def icon_name_for(o)
    Feather.icon_name_for(o)
  end

  def icon_for(o)
    Feather.get_icon(o)
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

  def svg_icon(name)
    Feather[name]
  end

  def svg_icon_for(o)
    Feather.get_icon(o)
  end

  def flag(name, attrs={})
    image_tag(asset_path("flags/#{name}.svg"),  attrs).html_safe
  end
end
