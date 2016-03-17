SettingsEditor.handlers.push
  type: 'string'
  save: (hidden) -> hidden.value = 'string'
  match: (v) -> v is 'string' or v.type is 'string'
  fake_value: -> 'preview string'

SettingsEditor.handlers.push
  type: 'markdown'
  save: (hidden) -> hidden.value = 'markdown'
  match: (v) -> v is 'markdown' or v.type is 'markdown'
  fake_value: -> 'preview string'
