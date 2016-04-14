{additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'resource'
  match: (v) -> v is 'resource' or v.type is 'resource'
  fake_value: -> ''
  save: (hidden) ->
    data = collect_setting_data('resource', hidden, 'required')
    hidden.value = format_setting_data(data)
  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)
    fields = $(required_field hidden)
    additional_field 'required', value, hidden, fields, on_update
    fields
