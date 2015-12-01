module NavigationHelper
  def nav_link_to(url, label, controller, ico=nil, options={}, &block)

    resource_class = controller == :home ? nil : controller.to_s.singularize.camelize.constantize

    ico, options = [nil, ico] if ico.is_a?(Hash)

    li_class = controller.to_s
    TPrint.debug options

    if block_given?
      li_class += ' dropdown'

      content_tag(:li, class: li_class) do
        opts = {class: 'dropdown-toggle', data: { toggle: 'dropdown' }}
        opts[:method] = options[:method] if options[:method].present?
        concat(link_to(url, opts) do
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
        opts = {}
        opts[:method] = options[:method] if options[:method].present?

        concat(link_to(url, opts) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
        end)
      end
    end
  end
end
