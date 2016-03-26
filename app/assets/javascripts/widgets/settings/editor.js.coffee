strip = (s) -> s.replace /^\s+|\s+$/g, ''
is_json = (s) -> s.match /^\{|^\[/
no_empty_string = (s) -> if strip(s) is '' then undefined else s
to_array = (v) -> String(v).split(',').map(strip)
light_unescape = (str) ->
  str
  .replace(/&lt;/g, '<')
  .replace(/&gt;/g, '>')
  .replace(/\\"/g, '"')

class window.SettingsEditor
  @Utils: {
    strip
    is_json
    no_empty_string
    to_array
    light_unescape
  }

  @handlers = []

  @handlers_by_type: -> o = {}; o[h.type] = h for h in @handlers; return o

  @handler_for_type: (type) -> @handlers_by_type()[type]

  @handler_for_type_or_value: (type) ->
    @handler_for_type(type) ? @handler_for_value(type)

  @handler_for_value: (value) ->
    res = @handlers.filter (h) -> h.match?(value)
    res[0]

  constructor: (@table) ->
    @add_button = @table.querySelector('.add')
    @row_blueprint = light_unescape @table.dataset.rowBlueprint
    @form = document.querySelector('form')

    rows = @table.querySelectorAll('tr')
    @num_rows = rows.length

    Array::forEach.call rows, (row) =>
      hidden = row.querySelector('input[type=hidden]')
      return unless hidden?

      @initialize_type(row, hidden)
      @register_row_events row

    @register_events()

  fake_form_values: (field_prefix) ->
    form_fields = []

    Array::forEach.call @table.querySelectorAll('tbody tr'), (row) =>
      old_input = row.querySelector('input[type=hidden]')

      return unless old_input?

      name = row.querySelector('input[type=text]').value
      type = old_input.value

      value = @get_value_for_type type

      new_field = document.createElement 'input'
      new_field.type = 'hidden'
      new_field.name = "#{field_prefix}[#{name}]"
      new_field.value = value

      form_fields.push new_field

    form_fields

  get_value_for_type: (type) ->
    @constructor.handler_for_type(type).fake_value?() ? ''

  append_row: (e) =>
    e.preventDefault()

    row = $(@row_blueprint)[0]
    hidden = row.querySelector('input[type=hidden]')
    hidden.id += @num_rows++

    @initialize_type(row, hidden)
    @register_row_events(row)

    last_row = @table.querySelector('tbody tr:last-child')
    @table.querySelector('tbody').insertBefore(row, last_row)

    $(row).trigger('nested:fieldAdded')

  initialize_type: (row, hidden, value) ->
    additional = row.querySelector('.additional')
    additional.innerHTML = ''

    original_value = value ? hidden.value
    original_value = JSON.parse(original_value) if is_json original_value

    original_type = @constructor.handler_for_type_or_value(original_value)

    if original_type?
      unless value?
        $select = $(row.querySelector('select'))
        $select.val(original_type.type).trigger('change')

      fields = original_type.additional_fields?(original_value, hidden)

      $(additional).append(fields) if fields?

      original_type.save(hidden) if value?

  register_row_events: (row) ->
    $row = $(row)
    $hidden = $row.find('input[type=hidden]').first()
    $input = $row.find('input[type=text]').first()
    $select = $row.find('select')
    $remove = $row.find('.remove')

    return unless $hidden.length > 0

    $input.on 'change input', =>
      $row.removeClass 'has-error'
      if @validate $input.val()
        $hidden.attr('name', "#{$(@table).data 'model'}[#{@table.getAttribute('data-attribute-name')}][#{$input.val()}]")
      else
        $row.addClass 'has-error'

    $select.on 'change', =>
      @initialize_type(row, $hidden[0], $select.val())

    $remove.on 'click', (e) ->
      e.preventDefault()
      $row.remove()

  validate: (value) -> /^[a-zA-Z_][a-zA-Z0-9_]*$/.test value

  register_events: ->
    $(@add_button).on 'click', @append_row
    $(@form).on 'submit', (e) =>
      if $(@table).find('.has-error').length > 0
        e.preventDefault()
        e.stopImmediatePropagation()
        return false
      else
        return true
