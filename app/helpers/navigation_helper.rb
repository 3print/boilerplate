module NavigationHelper
  def admin_nav_link_to(url, label = nil, controller_name = nil, ico = nil, options = {}, &block)
    if url.is_a?(Class)
      cls = url
      options = label if label.is_a?(Hash)
    end
    return if !block_given? && cls.present? && cannot?(:edit, cls)

    options[:dropdown] = true
    nav_link_to(url, label, controller_name, ico, options, &block)
  end

  def nav_link_to(url, label = nil, controller_name = nil, ico = nil, options = {}, &block)
    if url.is_a?(Class)
      cls = url
      options = label if label.is_a?(Hash)
      url = [controller.controller_namespace[0]] + [cls]
      label = cls.t
      controller_name = cls.name.pluralize.underscore
      ico = icon_class_for(cls)
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

    li_class = "nav-item #{controller_name.to_s}"

    if block_given?
      li_class += ' dropdown'

      content_tag(:li, class: li_class) do
        opts = {
          class: 'dropdown-toggle nav-link',
          "data-bs-toggle": 'dropdown',
        }

        opts[:method] = options[:method] if options[:method].present?
        concat(link_to(url, opts) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
          concat(get_badge(options[:badge])) if options[:badge].present?
        end)

        concat(content_tag(:ul, class: 'dropdown-menu') do
          concat(capture_haml(&block))
        end)
      end
    else
      content_tag(:li, class: li_class) do
        opts = {class: 'nav-link'}
        opts[:method] = options[:method] if options[:method].present?

        concat(link_to(url, opts) do
          concat(icon(ico)) if ico.present?
          concat(content_tag(:span, label))
          concat(get_badge(options[:badge])) if options[:badge].present?
        end)
      end
    end
  end

  def extra_menu_items(page)
    filename = "#{page.permalink.underscore}.html.haml"
    html = ""
    if lookup_context.exists? "_#{filename}", "shared/extra_menu_items"
      html = render partial: ["shared/extra_menu_items", filename].join('/'), locals: { page: page }
    end
    html
  end

  def admin_store_link_to(resource_class, options = {})
    if can?(:edit, resource_class)
      link_to [:admin, @store, resource_class], class: 'btn btn-secondary btn-lg btn-primary' do
        badge = options[:badge].present? ? get_badge(options[:badge]) : ''
        icon(icon_class_for(resource_class), class: 'fa-3x') +
          content_tag(:span, resource_class.t, class: 'text') + badge
      end
    end
  end

  def admin_store_nav_link_to(resource_class, options = {})
    if can?(:edit, resource_class)
      admin_nav_link_to [:admin, @store, resource_class], resource_class.t, resource_class.name.tableize, icon_class_for(resource_class), options
    end
  end

  def extra_menu_items_loaded?
    @sub_nav_links.present?
  end

  def sub_nav_link_to(url, label = nil, priority = 0, controller_name = nil, ico = nil, options = {}, &block)
    @sub_nav_links ||= []
    @sub_nav_links << [[url, label, controller_name, ico, options], priority]
  end

  def clear_sub_nav_links
    @sub_nav_links = []
  end

  def sub_nav_links
    @sub_nav_links.sort { |a, b| a[1] - b[1] }
  end

  def get_badge(count)
    count.positive? ? content_tag(:span, count, class: "badge") : ''
  end

  def load_extra_menu_items(page)
    filename = "#{page.permalink.underscore}.html.haml"
    html = ""
    if lookup_context.exists? "_#{filename}", "shared/extra_menu_items"
      html = render partial: ["shared/extra_menu_items", filename].join('/'), locals: { page: page }
    end
    html
  end
end
