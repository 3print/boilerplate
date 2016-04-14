{additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'string'
  match: (v) -> v is 'string' or v.type is 'string'
  fake_value: -> 'preview string'
  save: (hidden) ->
    data = collect_setting_data('string', hidden, 'required', 'textarea', 'limit')
    hidden.value = format_setting_data(data)
  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)
    html = """
    <div class="row">
      <div class="col-sm-3">
        #{required_field hidden}
      </div>
      <div class="col-sm-3">
        <div class="form-group">
          <div class="controls">
            <input
              type="checkbox"
              class="form-control"
              id="#{hidden.id}_textarea"
              data-name="textarea">
            </input>
            <label for="#{hidden.id}_textarea">#{"settings_input.string.textarea.label".t()}</label>
          </div>
        </div>
      </div>
      <div class="col-sm-6">
        <div class="form-group">
          <div class="controls">
            <label for="#{hidden.id}_limit">#{"settings_input.string.limit.label".t()}</label>
            <input
              type="number"
              class="form-control"
              step="1"
              id="#{hidden.id}_limit"
              placeholder="#{"settings_input.string.limit.placeholder".t()}"
              data-name="limit">
            </input>
          </div>
        </div>
      </div>
    </div>
    """

    fields = $(html)

    additional_field 'required', value, hidden, fields, on_update
    additional_field 'textarea', value, hidden, fields, on_update
    additional_field 'limit', value, hidden, fields, on_update

    fields

SettingsEditor.handlers.push
  type: 'markdown'
  match: (v) -> v is 'markdown' or v.type is 'markdown'
  fake_value: -> 'preview string'
  save: (hidden) ->
    data = collect_setting_data('markdown', hidden, 'required')
    hidden.value = format_setting_data(data)
  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)
    fields = $(required_field hidden)
    additional_field 'required', value, hidden, fields, on_update
    fields
