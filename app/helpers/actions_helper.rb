unless defined?(CLASSNAME_BY_ACTION)
  CLASSNAME_BY_ACTION = {
    index: 'secondary',
    destroy: 'danger',
    show: 'secondary',
    new: 'success',
    masquerade: 'warning'
  }
end

module ActionsHelper
  def classname_for_action(action)
    CLASSNAME_BY_ACTION[action.to_sym] || 'secondary'
  end
end
