module NavigationHelper
  def nav_link_to(url, label, controller, ico=nil, options={}, &block)
    ico, options = [nil, ico] if ico.is_a?(Hash)

    li_class = controller.to_s

    if block_given?
      li_class += ' dropdown'

      content_tag(:li, class: li_class) do
        concat(link_to(url, class: 'dropdown-toggle', data: { toggle: 'dropdown' }) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
          concat(icon('chevron-down'))
        end)

        concat(content_tag(:ul, class: 'dropdown-menu') do
          concat(capture_haml(&block))
        end)
      end
    else
      content_tag(:li, class: li_class) do
        concat(link_to(url) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
        end)
      end
    end
  end
end
