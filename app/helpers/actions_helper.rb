CLASSNAME_BY_ACTION = {
  index: 'secondary',
  destroy: 'danger',
  show: 'secondary',
  new: 'success',
  masquerade: 'warning'
}

module ActionsHelper
  def classname_for_action(action)
    CLASSNAME_BY_ACTION[action.to_sym] || 'secondary'
  end
end
