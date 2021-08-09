module NavigationHelper
  mattr_accessor :context

  SIDEBAR = {
    li_class: 'sidebar-item',
    a_class: 'sidebar-link',
    group_toggle: 'collapse',
    group_li_class: '',
    group_toggle_class: '',
    group_class: 'sidebar-dropdown list-unstyled collapse show',
  }
  NAVBAR = {
    li_class: 'nav-item',
    a_class: 'nav-link',
    group_toggle: 'dropdown',
    group_li_class: 'dropdown',
    group_toggle_class: 'dropdown-toggle',
    group_class: 'dropdown',
  }

  CONTEXTS = {
    sidebar: SIDEBAR,
    navbar: NAVBAR,
  }

  def with_nav_context(context, &block)
    self.context = CONTEXTS[context]
    capture_haml(&block)
  end

  def admin_nav_link_to(url, label = nil, controller_name = nil, ico = nil, options = {}, &block)
    if url.is_a?(Class)
      cls = url
      options = label if label.is_a?(Hash)
    end
    return if !block_given? && cls.present? && cannot?(:edit, cls)

    nav_link_to(url, label, controller_name, ico, options, &block)
  end

  def nav_link_to(url, label = nil, controller_name = nil, ico = nil, options = {}, &block)

    if url.is_a?(Class)
      cls = url
      options = label if label.is_a?(Hash)
      url = [controller.controller_namespace[0]] + [cls]
      label = cls.t
      controller_name = cls.name.pluralize.underscore
      ico = icon_name_for(cls)
    end

    url = options.delete(:url) if options[:url].present?
    label = options.delete(:label) if options[:label].present?
    ico = options.delete(:ico) if options[:ico].present?
    # rubocop:disable Lint/UselessAssignment
    resource_class = controller_name == :home ? nil : controller_name.to_s.singularize.camelize.constantize rescue nil
    # rubocop:enable Lint/UselessAssignment

    if ico.is_a?(Hash)
      options = ico
      ico = nil
    end

    li_class = "#{context[:li_class]} #{controller_name.to_s}"

    if block_given?
      li_class += " #{context[:group_li_class]}"

      content_tag(:li, class: li_class) do
        opts = {
          class: "#{context[:group_toggle_class]} #{context[:a_class]}",
          "data-bs-toggle": context[:group_toggle],
        }

        opts[:method] = options[:method] if options[:method].present?
        concat(link_to(url, opts) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
          concat(get_badge(options[:badge])) if options[:badge].present?
        end)

        concat(content_tag(:ul, class: context[:group_class]) do
          concat(capture_haml(&block))
        end)
      end
    else
      content_tag(:li, class: li_class) do
        opts = {class: context[:a_class]}
        opts[:method] = options[:method] if options[:method].present?

        concat(link_to(url, opts) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
          concat(get_badge(options[:badge])) if options[:badge].present?
        end)
      end
    end
  end
end
