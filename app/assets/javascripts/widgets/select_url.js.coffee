widgets.define 'select_url', (el) ->
  $el = $(el)

  $el.on 'change', ->
    url = $el.val()

    document.location = url unless url is ''
