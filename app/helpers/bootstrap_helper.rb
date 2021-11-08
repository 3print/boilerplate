module BootstrapHelper
  attr_accessor :current_accordion_id,
                :current_accordion_item_id,
                :current_dropdown_id,
                :current_tab_id

  def dropdown(label, options={}, &block)
    self.current_dropdown_id = options.delete(:id) || "dropdown_#{next_dropdown_id}"

    no_wrapper = options.delete(:wrapper)
    icon = options.delete(:icon)
    button_options = options.delete(:button) || {}
    dropdown_options = options.delete(:dropdown) || {}
    menu_options = options.delete(:menu) || {}

    html = capture_haml do
      concat(content_tag(:button, button_options.reverse_merge({
        id: current_dropdown_id,
        class: 'btn btn-outline-secondary dropdown-toggle',
        'data-bs-toggle': 'dropdown',
        'aria-expanded': false,
      })) do
        concat(icon + '&nbsp;'.html_safe) if icon.present?
        concat(label)
      end)
      concat(content_tag(:ul, menu_options.reverse_merge({
        class: 'dropdown-menu',
        'aria-labelledby': current_dropdown_id,
      }), &block))
    end

    no_wrapper ? html : content_tag(:div, dropdown_options.reverse_merge({
      class: 'btn-group',
    })) { concat(html) }
  end

  def dropdown_item(label, action=nil, options={}, &block)
    action, options = [label, action || {}] if block_given?
    action, options = [nil, action || {}] if action.is_a?(Hash)

    item_options = options.delete(:item) || {}
    link_options = options.delete(:link) || {}

    content_tag(:li, item_options) do
      if block_given?
        concat(link_to action, link_options.reverse_merge({
          class: 'dropdown-item',
        }), &block)
      else
        concat(link_to label, action, link_options.reverse_merge({
          class: 'dropdown-item',
        }))
      end
    end
  end

  def dropdown_separator
    content_tag(:li) do
      concat(tag.hr(class: 'dropdown-divider'))
    end
  end

  def tabs(options={}, &block)
    tabs_options = options.delete(:tabs) || {}
    tabs_content_options = options.delete(:tabs_content) || {}

    instance_exec(&block)

    tabs = @view_flow.get(:tab)
    tabs_content = @view_flow.get(:tab_content)

    html = capture_haml do
      concat(content_tag(:ul, tabs, tabs_options.reverse_merge({
        class: 'nav nav-tabs',
        role: :tablist,
      })))
      concat(content_tag(:div, tabs_content, tabs_content_options.reverse_merge({
        class: 'tab-content',
      })))
    end
  end

  def tab(label, options={}, &block)
    self.current_tab_id = options.delete(:id) || "tab_#{next_tab_id}"

    icon = options.delete(:icon)
    active = options.delete(:active) || false
    tab_options = options.delete(:tab) || {}
    tab_button_options = options.delete(:tab_button) || {}
    tab_content_options = options.delete(:tab_content) || {}

    tab = capture_haml do
      concat(content_tag(:li, tab_options.reverse_merge({
        class: 'nav-item',
        role: 'presentation',
      })) do
        concat(content_tag(:button, tab_button_options.reverse_merge({
          class: "nav-link#{active ? ' active' : ''}",
          id: "#{current_tab_id}_tab",
          type: :button,
          role: :tab,
          data: {
            bs_toggle: 'tab',
            bs_target: "##{current_tab_id}",
          },
          aria: {
            controls: current_tab_id,
            selected: active,
          }
        })) do
          concat(icon + '&nbsp;'.html_safe) if icon.present?
          concat(label)
        end)
      end)
    end

    tab_content = capture_haml do
      concat(content_tag(:div, tab_content_options.reverse_merge({
        id: current_tab_id,
        role: :tabpanel,
        class: "tab-pane#{active ? ' active' : ''}",
        'aria-labelledby': "#{current_tab_id}_tab",
      }), &block))
    end

    @view_flow.append(:tab, tab)
    @view_flow.append(:tab_content, tab_content)
    nil
  end

  def accordion(options={}, &block)
    self.current_accordion_id = options.delete(:id) || "accordion_#{next_accordion_id}"
    content_tag :div, options.reverse_merge(class: 'accordion', id: current_accordion_id), &block
  end

  def accordion_item(label, options={}, &block)
    self.current_accordion_item_id = options.delete(:id) || "#{current_accordion_id}_item_#{next_accordion_item_id}"

    icon = options.delete(:icon)
    expanded = options.delete(:expanded) || false
    item_options = options.delete(:item) || {}
    header_options = options.delete(:header) || {}
    header_button_options = options.delete(:header_button) || {}
    content_options = options.delete(:content) || {}

    content_tag :div, item_options.reverse_merge(class: 'accordion-item', id: current_accordion_item_id) do
      concat(content_tag( :h4, header_options.reverse_merge(class: 'accordion-header')) do
        concat(content_tag(:button, header_button_options.reverse_merge({
          class: "accordion-button #{expanded ? '' : 'collapsed'}",
          type: :button,
          data: {
            bs_toggle: 'collapse',
            bs_target: "##{current_accordion_item_id}_collapse"
          },
          aria: {
            expanded: expanded,
            controls: "#{current_accordion_item_id}_collapse"
          },
        })) do
          concat(icon + '&nbsp;'.html_safe) if icon.present?
          concat(label)
        end)
      end)
      concat(content_tag(:div, content_options.reverse_merge({
        class: "accordion-collapse collapse #{expanded ? 'show' : ''}",
        id: "#{current_accordion_item_id}_collapse",
        aria_labelledby: "headingFour",
        data: {
          bs_parent: "##{current_accordion_id}"
        }
      })) do
        concat(content_tag :div, class: 'accordion-body', &block)
      end)
    end
  end

  def card(title=nil, options={}, &block)
    icon = options.delete(:icon)
    card_options = options.delete(:card) || {}
    card_header_options = options.delete(:header) || {}
    content_tag :div, card_options.reverse_merge(class: 'card') do
      if title.present?

        concat(content_tag(:div, card_header_options.reverse_merge(class: 'card-header')) do
          concat(content_tag(:h5, class: 'card-title mb-0') do
            concat(icon + '&nbsp;'.html_safe) if icon.present?
            concat(title)
          end)
        end)
      end

      concat(capture_haml(&block))
    end
  end

  %w(accordion accordion_item dropdown tab).each do |k|
    name = "next_#{k}_id"
    var_name = "@#{name}"
    define_method name do
      if !instance_variable_defined?(var_name)
        instance_variable_set(var_name, 0)
      end

      instance_variable_set(var_name, instance_variable_get(var_name) + 1)
      instance_variable_get(var_name)
    end
  end
end
