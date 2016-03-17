SettingsEditor.handlers.push
  type: 'boolean'
  save: (hidden) -> hidden.value = 'boolean'
  match: (v) -> v is 'boolean' or v.type is 'boolean'
  fake_value: -> Math.random() > 0.5
