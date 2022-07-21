
unless defined?(CLASSNAME_BY_ACTION)
  CLASSNAME_BY_ACTION = {
    index: 'secondary',
    destroy: 'danger',
    show: 'primary',
    new: 'success',
    masquerade: 'warning',
    edit: 'primary',
    pdf: 'primary',
    more: 'primary',
  }
end

module ActionsHelper
  def classname_for_action(action)
    CLASSNAME_BY_ACTION[action.to_sym] || 'secondary'
  end

  def button_class_for_action(action)
    "btn btn-outline-#{classname_for_action(action)}"
  end

  def action_button_for(action, resource=nil, options={})
    if can? action, resource
      title = "actions.#{action}".t
      label = icon_and_text(title, icon_name_for(action))

      unless_clause = options.delete(:unless)
      if unless_clause.present?
        return if instance_exec(&unless_clause)
      end
      if_clause = options.delete(:if)
      if if_clause.present?
        return unless instance_exec(&if_clause)
      end

      link_to label, resolve_action_url(action, resource), {class: button_class_for_action(action)}.merge(options)
    end
  end

  def actions_dropdown(label, resource, actions)
    title = "actions.#{label}".t
    content_tag(:div, class: 'btn-group') do
      concat(content_tag(:button, class: button_class_for_action(label) + ' dropdown-toggle no-caret', 'data-bs-toggle': 'dropdown', title: title) do
        concat(icon_for(label))
        concat(content_tag(:span, title, class: 'text'))
      end)
      concat(content_tag(:div, class: 'dropdown-menu') do
        concat(actions_buttons(actions, resource).map {|b| b.gsub(/a class="[^"]*"/, 'a class="dropdown-item"') }.join.html_safe)
      end)
    end
  end

  def actions_buttons(actions, resource)
    actions.map do |a|
      if a.is_a?(Hash)
        a.map do |k,v|
          if v.is_a?(Proc)
            instance_exec(resource, &v)
          else
            action_button_for(k, resource, v)
          end
        end
      else
        action_button_for(a, resource)
      end
    end.flatten.compact
  end

  def resolve_action_url(action, resource)
    base = controller.is_admin? ? [:admin] : []
    case action.to_s
    when 'update' then base + [resource]
    when 'create' then base + [resource.class]
    when 'index' then base + [resource.class]
    when 'destroy' then base + [resource]
    when 'show' then base + [resource]
    when 'new' then [:new] + base + [singular]
    when 'pdf' then [:pdf] + base + [resource, format: :pdf]
    else
      [action.to_sym] + base + [resource]
    end
  end
end
