module NavigationHelper
  mattr_accessor :context

  SIDEBAR = {
    li_class: 'sidebar-item',
    a_class: 'sidebar-link',
    group_toggle: 'collapse',
    group_li_class: '',
    group_toggle_class: '',
    group_class: 'sidebar-dropdown list-unstyled collapse show',
    badge_class: 'sidebar-badge badge bg-primary',
  }
  NAVBAR = {
    li_class: 'nav-item',
    a_class: 'nav-link',
    group_toggle: 'dropdown',
    group_li_class: 'dropdown',
    group_toggle_class: 'dropdown-toggle',
    group_class: 'dropdown',
    badge_class: 'badge bg-primary',
  }

  CONTEXTS = {
    sidebar: SIDEBAR,
    navbar: NAVBAR,
  }

  def with_nav_context(context, &block)
    self.context = CONTEXTS[context]
    capture_haml(&block)
  end

  def admin_nav_link_to(url, options = {}, &block)
    cls = nil
    if url.is_a?(Class)
      cls = url
    elsif url.is_a?(ApplicationRecord)
      cls = url
    end

    return if !block_given? && cls.present? && cannot?(:edit, cls)

    nav_link_to(url, options, &block)
  end

  def nav_link_to(url, options = {}, &block)

    if url.is_a?(Class)
      cls = url
      url = [controller.controller_namespace[0]] + [cls]
      label = cls.t
      controller_name = cls.name.pluralize.underscore
      ico = icon_name_for(cls)
    elsif url.is_a?(ApplicationRecord)
      cls = url
      options = label if label.is_a?(Hash)
      url = [controller.controller_namespace[0]] + [cls]
      label = resource_label_for(cls)
      controller_name = cls.class.name.pluralize.underscore
      ico = icon_name_for(cls.class)
    else
      label = options[:label]
      ico = options[:icon]
      controller_name = options[:controller_name] || :home
    end

    # rubocop:disable Lint/UselessAssignment
    resource_class = controller_name == :home ? nil : controller_name.to_s.singularize.camelize.constantize rescue nil
    # rubocop:enable Lint/UselessAssignment

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
          concat(get_badge(options[:badge], options[:badge_tooltip])) if options[:badge].present?
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
          concat(get_badge(options[:badge], options[:badge_tooltip])) if options[:badge].present?
        end)
      end
    end
  end

  def get_badge(label, tooltip=nil)
    content_tag :span, class: context[:badge_class], title: tooltip do
      concat(label)
    end
  end
end
