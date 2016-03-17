#= require widgets/settings/editor
#= require widgets/settings/form
#= require_tree ./settings/handlers

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)

widgets.define 'settings_form', (el) ->
  $el = $(el)
  $el.data 'form', form = new SettingsForm($el.data('settings'), $el.data('values'))
  $el.append form.render()

  setTimeout (-> $el.trigger('nested:fieldAdded')), 100
