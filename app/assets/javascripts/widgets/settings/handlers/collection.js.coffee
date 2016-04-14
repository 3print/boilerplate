{to_array, additional_field, required_field, collect_setting_data} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'collection'
  match: (v) ->
    (typeof v is 'string' and v.indexOf(',') >= 0) or v.type is 'collection'
  fake_value: -> ['foo','bar','baz']
  save: (hidden) ->
    data = collect_setting_data('collection', hidden, 'required', 'multiple')
    data.values = to_array hidden.values_input.val()
    hidden.value = JSON.stringify(data)

  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)

    value = if value.values? then value else values: to_array value
    fields = $ """
      <div class="form-group">
        <label for="#{hidden.id}_collection_values">#{'settings_input.collection.values.label'.t()}</label>
        <div class="controls">
          <input type="text"
                 class="form-control"
                 id="#{hidden.id}_collection_values"
                 data-name="values"
                 placeholder="#{'settings_input.collection.values.placeholder'.t()}"
                 required>
          </input>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-6">
          #{required_field(hidden)}
        </div>
        <div class="col-sm-6">
          <div class="form-group">
            <div class="controls">
              <input
                type="checkbox"
                class="form-control"
                id="#{hidden.id}_multiple"
                data-name="multiple">
              </input>
              <label for="#{hidden.id}_multiple">#{"settings_input.collection.multiple.label".t()}</label>
            </div>
          </div>
        </div>
      </div>
    """

    additional_field 'values', value, hidden, fields, on_update
    additional_field 'required', value, hidden, fields, on_update
    additional_field 'multiple', value, hidden, fields, on_update

    fields
