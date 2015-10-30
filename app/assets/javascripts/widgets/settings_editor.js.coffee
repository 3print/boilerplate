strip = (s) -> s.replace /^\s+|\s+$/g, ''

class SettingsEditor
  constructor: (@table) ->
    @add_button = @table.querySelector('.add')
    @row_blueprint = @light_unescape @table.dataset.rowBlueprint
    @form = document.querySelector('form')
    @domBuilder = document.createElement('div')

    Array::forEach.call @table.querySelectorAll('tr'), (row) =>
      hidden = row.querySelector('input[type=hidden]')
      select = row.querySelector('select')
      @construct_additional_field($(select), $(hidden))
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
    switch type
      when 'boolean' then Math.random() > 0.5
      when 'integer' then Math.round(Math.random() * 100)
      when 'float' then Math.random() * 10
      when 'string' then 'preview string'
      else
        a = type.split(',')
        i = Math.floor(Math.random() * a.length)
        a[i]

  append_row: (e) =>
    e.preventDefault()

    row = $(@row_blueprint)[0]
    @domBuilder.innerHTML = ''
    @register_row_events(row)

    last_row = @table.querySelector('tbody tr:last-child')
    @table.querySelector('tbody').insertBefore(row, last_row)

    $(row).trigger('nested:fieldAdded')

  collection_update: (hidden) -> ->
    hidden.value = $(@).val().split(',').map strip

  construct_additional_field: ($select, $hidden) ->
    $additional = $select.parent().find('.additional')
    $additional.next().remove()
    $additional.remove()

    original_type = $select.data('original-type')
    original_value = $select.data('original-value')

    switch $select.val()
      when 'collection'
        collection_input = $ '<input type="text" class="form-control additional" data-type="collection"></input>'

        collection_input.on 'change', @collection_update($hidden)

        $select.parent().append collection_input

        collection_input.val original_value if original_value? and original_type is 'collection'
      else
        $hidden.val($select.val())

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
      @construct_additional_field($select, $hidden)

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

  light_unescape: (str) ->
    str
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/\\"/g, '"')

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)
