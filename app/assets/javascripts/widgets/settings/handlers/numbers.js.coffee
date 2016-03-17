{no_empty_string} = SettingsEditor.Utils

get_handler = (name) ->
  type: name

  match: (v) -> v is name or v.type is name

  fake_value: -> Math.round(Math.random() * 100)

  save: (hidden) ->
    min = no_empty_string hidden.min_input.val()
    max = no_empty_string hidden.max_input.val()

    if min? or max?
      data = type: name
      data.min = min if min?
      data.max = max if max?
      hidden.value = JSON.stringify(data)
    else
      hidden.value = name

  additional_fields: (value, hidden) ->
    update = => @save(hidden)
    additional_fields = $ """
      <div class="row">
        <div class="col-sm-6">
          <label>#{"settings_input.#{name}.min.label".t()}</label>
          <input
            type="number"
            class="form-control"
            #{if name is 'integer' then 'step="1"' else ''}
            placeholder="#{"settings_input.#{name}.min.placeholder".t()}"
            data-name="min">
          </input>
        </div>
        <div class="col-sm-6">
          <label>#{"settings_input.#{name}.max.label".t()}</label>
          <input
            type="number"
            class="form-control"
            #{if name is 'integer' then 'step="1"' else ''}
            placeholder="#{"settings_input.#{name}.max.placeholder".t()}"
            data-name="max">
          </input>
        </div>
      </div>
    """

    min_input = additional_fields.find('[data-name="min"]')
    max_input = additional_fields.find('[data-name="max"]')

    hidden.min_input = min_input
    hidden.max_input = max_input

    min_input.on 'change', update
    max_input.on 'change', update

    min_input.val value.min if value.min?
    max_input.val value.max if value.max?

    additional_fields

SettingsEditor.handlers.push get_handler 'integer'
SettingsEditor.handlers.push get_handler 'float'
