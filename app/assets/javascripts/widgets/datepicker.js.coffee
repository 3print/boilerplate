
widgets.define 'datepicker', (el) ->
  $el = $(el)
  $clone = $("<input type='text' name='#{$el.attr('name')}' value='#{$el.val()}' id='#{$el.attr('id')}' class='#{$el.attr('class')}' placeholder='#{$el.attr('placeholder')}'></input>")
  $el.after($clone)
  $el.remove()

  $clone.datepicker defaultDate: "+1w", numberOfMonths: 2, format: 'yyyy-mm-dd', altFormat: 'dd/mm/yyyy', language: 'fr'

widgets.define 'datepicker_mobile', (el) ->
  $el = $(el)
  if $el.val() isnt ''
    v = $el.val().replace(' ', 'T') + 'Z'
    value = new Date().toISOString()
  else
    value = ''
  $handler = $("<input type='datetime-local' value='#{value}' class='overlay' placeholder='#{$el.attr('placeholder')}'>")
  $el.after($handler)

  $handler.on 'change', ->
    $el.val $handler.val().replace('T', ' ')
