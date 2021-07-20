//= require widgets/settings/editor
//= require widgets/settings/form
//= require_tree ./settings/handlers

widgets.define('settings_editor', el => $(el).data('editor', new SettingsEditor(el)));

widgets.define('settings_form', function(el) {
  let form;
  let $el = $(el);
  $el.data('form', (form = new SettingsForm($el)));
  let $form = $(form.render());

  $form.find('[required="no"]').each(function() {
    let $input = $(this);
    $input.parents('.has-feedback').removeClass('has-feedback');
    $input.removeAttr('required');
    return true;
  });

  $form.find('[multiple="no"]').each(function() {
    let $input = $(this);
    $input.removeAttr('multiple');
    return true;
  });

  $el.append($form);

  return setTimeout((() => $el.trigger('nested:fieldAdded')), 100);
});
