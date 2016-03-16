#= require widgets/settings/editor

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)
