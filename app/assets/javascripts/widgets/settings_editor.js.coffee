#= require widgets/settings/editor
#= require widgets/settings/form
#= require_tree ./settings/handlers

widgets.define 'settings_editor', (el) ->
  $(el).data 'editor', new SettingsEditor(el)

widgets.define 'settings_form', (el) ->
  $el = $(el)
  $el.data 'form', form = new SettingsForm($el)
  $form = $(form.render())

  $form.find('[required="no"]').each ->
    $input = $(this)
    $input.parents('.has-feedback').removeClass('has-feedback')
    $input.removeAttr('required')
    true

  $form.find('[multiple="no"]').each ->
    $input = $(this)
    $input.removeAttr('multiple')
    true

  $el.append($form)

  setTimeout (-> $el.trigger('nested:fieldAdded')), 100
