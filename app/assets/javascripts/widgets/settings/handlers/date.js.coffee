SettingsEditor.handlers.push
  type: 'date'
  save: (hidden) -> hidden.value = 'date'
  match: (v) -> v is 'date' or v.type is 'date'
  fake_value: -> new Date()

SettingsEditor.handlers.push
  type: 'datetime'
  save: (hidden) -> hidden.value = 'datetime'
  match: (v) -> v is 'datetime' or v.type is 'datetime'
  fake_value: -> new Date()

SettingsEditor.handlers.push
  type: 'time'
  save: (hidden) -> hidden.value = 'time'
  match: (v) -> v is 'time' or v.type is 'time'
  fake_value: -> new Date()
