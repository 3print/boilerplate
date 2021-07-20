let validate_presence = function(t) {
  if ((t != null) && (t !== '')) {
    return null;
  } else {
    return 'widgets.validation.blank'.t();
  }
};

let validate_email = t =>
  validate_presence(t) || (/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/.test(t.toUpperCase()) ?
    null
  :
    'widgets.validation.invalid_email'.t())
;

widgets.VALIDATORS = {
  text: validate_presence,
  number: validate_presence,
  email: validate_email
};

let validate = function(input) {
  let res;
  let $input = $(input);
  let $form_group = $input.parents('.form-group').first();
  let $controls = $form_group.find('.form-control');
  let type = $input.attr('type');
  let value = $input.val();

  $form_group.removeClass('has-success').removeClass('has-error');
  $controls.removeClass('is-valid').removeClass('is-invalid');
  $form_group.find('.form-control-feedback, .alert').remove();

  if (type != null) {
    res = (widgets.VALIDATORS[type] != null ? widgets.VALIDATORS[type] : validate_presence)(value);
  } else {
    res = validate_presence(value);
  }

  if (res != null) {
    $form_group.addClass('has-error');
    $controls.addClass('is-invalid');
    $controls.parent().append(`<div class='alert alert-danger'>${res}</div>`);
    return true;
  } else {
    $controls.addClass('is-valid');
    $form_group.addClass('has-success');
    return false;
  }
};

widgets.define('live_validation', function(el) {
  let $input = $(el);
  return $input.on('change blur', function() { return validate(this); });
});

widgets.define('form_validation', function(form) {
  let $form = $(form);
  $form.attr('novalidate', 'novalidate');

  return $form.submit(function(e) {
    let $required =
    $form.find('.has-success, .has-error').removeClass('has-success').removeClass('has-error');
    $form.find('.is-valid, .is-invalid').removeClass('is-valid').removeClass('is-invalid');
    $form.find('.form-control-feedback, .alert').remove();

    let has_errors = false;

    $form.find('[required]').each(function() {
      has_errors = validate(this) || has_errors;
      return true;
    });

    if (has_errors) { e.stopImmediatePropagation(); }
    return !has_errors;
  });
});
