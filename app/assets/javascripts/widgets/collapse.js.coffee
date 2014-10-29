widgets.define 'collapse', (el) ->
  $el = $(el)
  $el.collapse(toggle: false).on 'show.bs.collapse hide.bs.collapse', (e) ->
    e.preventDefault()
