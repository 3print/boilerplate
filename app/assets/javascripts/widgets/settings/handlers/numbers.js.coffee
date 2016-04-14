{additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils

fields = ['default', 'min', 'max', 'step']

get_handler = (name) ->
  type: name

  match: (v) -> v is name or v.type is name

  fake_value: -> Math.round(Math.random() * 100)

  save: (hidden) ->
    data = collect_setting_data(name, hidden, 'required', fields...)
    hidden.value = format_setting_data(data)

  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)

    html = '<div class="row">'
    fields.forEach (key) ->
      html += """
        <div class="col-sm-3">
          <label for="#{hidden.id}_#{key}">#{"settings_input.#{name}.#{key}.label".t()}</label>
          <input
            type="number"
            class="form-control"
            id="#{hidden.id}_#{key}"
            #{if name is 'integer' then 'step="1"' else ''}
            placeholder="#{"settings_input.#{name}.#{key}.placeholder".t()}"
            data-name="#{key}">
          </input>
        </div>
      """
    html += '</div>'
    html += required_field(hidden)

    additional_fields = $(html)

    additional_field 'required', value, hidden, additional_fields, on_update
    fields.forEach (key) ->
      additional_field key, value, hidden, additional_fields, on_update

    additional_fields

SettingsEditor.handlers.push get_handler 'integer'
SettingsEditor.handlers.push get_handler 'float'
