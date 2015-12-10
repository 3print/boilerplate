CLASSNAME_BY_ACTION = {
  index: 'default',
  destroy: 'danger',
  show: 'default',
  new: 'success',
  masquerade: 'warning'
}

module ActionsHelper
  def classname_for_action(action)
    CLASSNAME_BY_ACTION[action.to_sym] || 'default'
  end
end
