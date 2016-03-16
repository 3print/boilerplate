strip = (s) -> s.replace /^\s+|\s+$/g, ''
is_json = (s) -> s.match /^\{|^\[/
to_array = (v) -> String(v).split(',').map(strip)
light_unescape = (str) ->
  str
  .replace(/&lt;/g, '<')
  .replace(/&gt;/g, '>')
  .replace(/\\"/g, '"')

class window.SettingsEditor
  @handlers = [
    {
      type: 'integer'
      save: (hidden) -> hidden.value = 'integer'
      match: (v) -> v is 'integer' or v.type is 'integer'
      fake_value: -> Math.round(Math.random() * 100)
    }
    {
      type: 'float'
      save: (hidden) -> hidden.value = 'float'
      match: (v) -> v is 'float' or v.type is 'float'
      fake_value: -> Math.random() * 10
    }
    {
      type: 'string'
      save: (hidden) -> hidden.value = 'string'
      match: (v) -> v is 'string' or v.type is 'string'
      fake_value: -> 'preview string'
    }
    {
      type: 'boolean'
      save: (hidden) -> hidden.value = 'boolean'
      match: (v) -> v is 'boolean' or v.type is 'boolean'
      fake_value: -> Math.random() > 0.5
    }
    {
      type: 'markdown'
      save: (hidden) -> hidden.value = 'markdown'
      match: (v) -> v is 'markdown' or v.type is 'markdown'
      fake_value: -> 'preview string'
    }
    {
      type: 'date'
      save: (hidden) -> hidden.value = 'date'
      match: (v) -> v is 'date' or v.type is 'date'
      fake_value: -> new Date()
    }
    {
      type: 'image'
      save: (hidden) -> hidden.value = 'image'
      match: (v) -> v is 'image' or v.type is 'image'
      fake_value: -> ''
    }
    {
      type: 'collection'
      match: (v) ->
        (typeof v is 'string' and v.indexOf(',') >= 0) or v.type is 'collection'
      fake_value: -> ['foo','bar','baz']
      save: (hidden) ->
        hidden.value = JSON.stringify({
          type: 'collection'
          values: to_array hidden.collection_input.val()
        })

      additional_fields: (value, hidden) ->
        normalize_value = (v) -> v.values ? to_array v
        collection_update = => @save(hidden)
        collection_input = $ """
          <label>#{'settings_input.collection.values.label'.t()}</label>
          <input type="text"
                 class="form-control"
                 data-type="collection"
                 placeholder="#{'settings_input.collection.values.placeholder'.t()}">
          </input>
        """

        hidden.collection_input = collection_input

        collection_input.on 'change', collection_update
        collection_input.val normalize_value(value) unless value is 'collection'
        collection_input
    }
  ]

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

    Array::forEach.call @table.querySelectorAll('tr'), (row) =>
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
    $hidden = $row.find('input[type=hidden]')
    $input = $row.find('input[type=text]')
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

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)
