SettingsEditor.handlers.push
  type: 'date'
  save: (hidden) -> hidden.value = 'date'
  match: (v) -> v is 'date' or v.type is 'date'
  fake_value: -> new Date()
