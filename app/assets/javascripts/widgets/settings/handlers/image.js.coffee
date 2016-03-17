SettingsEditor.handlers.push
  type: 'image'
  save: (hidden) -> hidden.value = 'image'
  match: (v) -> v is 'image' or v.type is 'image'
  fake_value: -> ''
