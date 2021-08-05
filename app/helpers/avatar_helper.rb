module AvatarHelper
  def show_avatar(avatar, version, options={})
    if avatar.present?
      content_tag(:div, class: "avatar #{version} #{options[:class]}") do
        concat(image_tag(avatar.send(version).url))
      end
    else
      content_tag(:div, class: "avatar default #{version} #{options[:class]}") do
        concat(icon(:user))
      end
    end
  end
end
