widgets.define 'navigation_highlight', (nav) ->

  if document.body.classList.length
    current_controller = document.body.className.split(' ').map((s) -> ".#{s}").join(', ')

    active = nav.querySelector(current_controller)
    if active?
      active.classList.add 'active'
      nav.classList.add 'has-active'

      if (parent = active.parentNode.parentNode).nodeName is 'LI'
        parent.classList.add 'active'
