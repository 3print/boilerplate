widgets.define 'collapse', (el) ->
  $el = $(el)
  $el.collapse(toggle: false).on 'show.bs.collapse hide.bs.collapse', (e) ->
    e.preventDefault()

widgets.define 'collapse_toggle', (el) ->
  $el = $(el)
  $el.on 'click', (e) ->
    $target = $($el.data('target'))
    $target.toggleClass('collapse')
