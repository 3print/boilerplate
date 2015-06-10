
widgets.define 'datepicker', (el) ->
  $el = $(el)

  try
    $el.datetimepicker
      format: 'YYYY-MM-DD'
      displayFormat: 'DD/MM/YYYY'
      locale: 'fr'
      # inline: true
      calendarWeeks: true
      sideBySide: true
  catch e
    console.error(e)

widgets.define 'datetimepicker', (el) ->
  $el = $(el)

  try
    $el.datetimepicker
      format: 'YYYY-MM-DD HH:mm'
      displayFormat: 'DD/MM/YYYY HH:mm'
      locale: 'fr'
      # inline: true
      calendarWeeks: true
      sideBySide: true
  catch e
    console.error(e)

widgets.define 'datepicker_mobile', (el) ->
  $el = $(el)
  if $el.val() isnt ''
    v = $el.val().replace(' ', 'T') + 'Z'
    value = new Date().toISOString()
  else
    value = ''
  $handler = $("""
    <input type='datetime-local'
           value='#{value}'
           class='overlay'
           placeholder='#{$el.attr('placeholder')}'>
    </input>
  """)
  $el.after($handler)

  $handler.on 'change', ->
    $el.val $handler.val().replace('T', ' ')
