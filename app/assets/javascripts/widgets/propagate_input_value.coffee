widgets.define 'propagate_input_value', (el) ->
  $el = $(el)
  propagate = -> $el.parents('.form-group').attr('data-value', $el.val())
  propagate() if $el.is('[type=radio]:checked')
  propagate() if !$el.is('[type=radio]')
  $el.on 'change', -> propagate()
