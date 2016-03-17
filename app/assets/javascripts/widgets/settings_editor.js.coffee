#= require widgets/settings/editor
#= require_tree ./settings/handlers

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)
