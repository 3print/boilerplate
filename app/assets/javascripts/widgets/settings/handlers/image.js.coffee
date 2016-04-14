{additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils

SettingsEditor.handlers.push
  type: 'image'
  match: (v) -> v is 'image' or v.type is 'image'
  fake_value: -> ''
  save: (hidden) ->
    data = collect_setting_data('image', hidden, 'required')
    hidden.value = format_setting_data(data)
  additional_fields: (value, hidden) ->
    on_update = => @save(hidden)
    fields = $(required_field hidden)
    additional_field 'required', value, hidden, fields, on_update
    fields
