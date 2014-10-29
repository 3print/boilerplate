widgets.define 'navigation_highlight', (body) ->

  if body.classList.length
    nav = document.querySelector('.navbar-nav')

    current_controller = body.className.split(' ').map((s) -> ".#{s}").join(', ')

    active = nav.querySelector(current_controller)
    if active?
      active.classList.add 'active'
      nav.classList.add 'has-active'
