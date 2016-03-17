{no_empty_string} = SettingsEditor.Utils

fields = ['default', 'min', 'max', 'step']

get_handler = (name) ->
  type: name

  match: (v) -> v is name or v.type is name

  fake_value: -> Math.round(Math.random() * 100)

  save: (hidden) ->
    values = fields.map (key) -> no_empty_string hidden["#{key}_input"].val()

    if values.some((v) -> v?)
      data = type: name

      fields.forEach (key, i) ->
        value = values[i]
        data[key] = value if value?

      hidden.value = JSON.stringify(data)
    else
      hidden.value = name

  additional_fields: (value, hidden) ->
    update = => @save(hidden)
    html = '<div class="row">'
    fields.forEach (key) ->
      html += """
        <div class="col-sm-3">
          <label>#{"settings_input.#{name}.#{key}.label".t()}</label>
          <input
            type="number"
            class="form-control"
            #{if name is 'integer' then 'step="1"' else ''}
            placeholder="#{"settings_input.#{name}.#{key}.placeholder".t()}"
            data-name="#{key}">
          </input>
        </div>
      """
    html += '</div>'

    additional_fields = $(html)

    fields.forEach (key) ->
      input = additional_fields.find("[data-name=\"#{key}\"]")
      hidden["#{key}_input"] = input
      input.on 'change', update
      input.val value[key] if value[key]?

    additional_fields

SettingsEditor.handlers.push get_handler 'integer'
SettingsEditor.handlers.push get_handler 'float'
