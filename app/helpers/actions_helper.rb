
unless defined?(CLASSNAME_BY_ACTION)
  CLASSNAME_BY_ACTION = {
    index: 'secondary',
    destroy: 'danger',
    show: 'primary',
    new: 'success',
    masquerade: 'warning',
    edit: 'primary',
    pdf: 'primary',
  }
end

module ActionsHelper
  def classname_for_action(action)
    CLASSNAME_BY_ACTION[action.to_sym] || 'secondary'
  end

  def button_class_for_action(action)
    "btn btn-outline-#{classname_for_action(action)}"
  end
end
