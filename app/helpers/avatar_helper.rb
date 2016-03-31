module AvatarHelper
  def show_avatar(avatar, version, options={})
    if avatar.present?
      content_tag(:div, class: "avatar #{version} #{options[:class]}") do
        concat(image_tag(avatar.send(version)))
      end
    else
      content_tag(:div, class: "avatar default #{version} #{options[:class]}") do
        concat(image_tag("avatar-#{version}-placeholder.png"))
        concat(content_tag(:svg, role: :img, version: 1.1, viewBox:"0 0 1792 1792") do
          concat(content_tag(:path, '', d: "M1600 1405q0 120-73 189.5t-194 69.5h-874q-121 0-194-69.5t-73-189.5q0-53 3.5-103.5t14-109 26.5-108.5 43-97.5 62-81 85.5-53.5 111.5-20q9 0 42 21.5t74.5 48 108 48 133.5 21.5 133.5-21.5 108-48 74.5-48 42-21.5q61 0 111.5 20t85.5 53.5 62 81 43 97.5 26.5 108.5 14 109 3.5 103.5zm-320-893q0 159-112.5 271.5t-271.5 112.5-271.5-112.5-112.5-271.5 112.5-271.5 271.5-112.5 271.5 112.5 112.5 271.5z"))
        end)
      end
    end
  end
end
