widgets.define 'drawer', (trigger, options) ->
  overlay = document.querySelector('.drawer-overlay')

  openDrawer = ->
    document.body.classList.add('drawer-open')

  closeDrawer = ->
    document.body.classList.remove('drawer-open')
    document.querySelector('.subdrawer.visible')?.classList.remove('visible')
    document.querySelector('[data-toggle="subdrawer"].open')?.classList.remove('open')
    setTimeout ->
      document.querySelector('.drawer').classList.remove('subdrawer-open')
    , 300

  overlay.addEventListener 'click', -> closeDrawer()

  trigger.addEventListener 'click', ->
    if document.body.classList.contains('drawer-open')
      closeDrawer()
    else
      openDrawer()

widgets.define 'drawer_menu', (menuLink, options) ->
  target = document.querySelector(menuLink.getAttribute('data-target'))
  closeButton = target.querySelector('button')
  closeButton.addEventListener 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()

    document.querySelector('.drawer').classList.remove('subdrawer-open')
    document.querySelector('.subdrawer.visible')?.classList.remove('visible')
    document.querySelector('[data-toggle="subdrawer"].open')?.classList.remove('open')

  menuLink.addEventListener 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()

    document.querySelector('.subdrawer.visible')?.classList.remove('visible')
    document.querySelector('[data-toggle="subdrawer"].open')?.classList.remove('open')

    document.querySelector('.drawer').classList.add('subdrawer-open')
    target.classList.add('visible')
    menuLink.classList.add('open')
