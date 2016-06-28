
widgets.define 'datepicker', (el) ->
  $el = $(el)

  if (date = moment($el.val(), DATE_DISPLAY_FORMAT)).isValid()
    $el.val(date.format(DATE_FORMAT))

  try
    $el.on 'change', ->
      if (date = moment($el.val(), DATE_DISPLAY_FORMAT)).isValid()
        $el.val(date.format(DATE_FORMAT))

    $el.datetimepicker
      format: DATE_FORMAT
      displayFormat: DATE_DISPLAY_FORMAT
      locale: 'fr'
      # inline: true
      calendarWeeks: true
      sideBySide: true
  catch e
    console.error(e)

widgets.define 'datetimepicker', (el) ->
  $el = $(el)

  if (date = moment($el.val(), DATETIME_DISPLAY_FORMAT)).isValid()
    $el.val(date.format(DATETIME_FORMAT))

  try
    $el.on 'change', ->
      if (date = moment($el.val(), DATETIME_DISPLAY_FORMAT)).isValid()
        $el.val(date.format(DATETIME_FORMAT))

    $el.datetimepicker
      format: DATETIME_FORMAT
      displayFormat: DATETIME_DISPLAY_FORMAT
      locale: 'fr'
      # inline: true
      calendarWeeks: true
      sideBySide: true
  catch e
    console.error(e)

widgets.define 'timepicker', (el) ->
  $el = $(el)

  if (date = moment($el.val(), TIME_DISPLAY_FORMAT)).isValid()
    $el.val(date.format(TIME_FORMAT))

  try
    $el.on 'change', ->
      if (date = moment($el.val(), TIME_DISPLAY_FORMAT)).isValid()
        $el.val(date.format(TIME_FORMAT))

    $el.datetimepicker
      format: TIME_FORMAT
      displayFormat: TIME_DISPLAY_FORMAT
      locale: 'fr'
      # inline: true
      calendarWeeks: true
      sideBySide: true
  catch e
    console.error(e)

widgets.define 'datepicker_mobile', (el) ->
  $el = $(el)

  type = switch true
    when $el.hasClass('datetimepicker') then 'datetime'
    when $el.hasClass('datepicker') then 'date'
    when $el.hasClass('timepicker') then 'time'

  if $el.val() isnt ''
    value = new Date($el.val()).toISOString()
  else
    value = ''

  $handler = $("""
    <input type='#{type}' value='#{value}' class='form-control'></input>
  """)

  $handler.attr('name', $el.attr('name')) if $el.attr('name')
  $handler.attr('placeholder', $el.attr('placeholder')) if $el.attr('placeholder')

  $el.after($handler)
  $el.remove()
