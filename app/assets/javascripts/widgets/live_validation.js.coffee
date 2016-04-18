validate_presence = (t) ->
  if t? and t isnt ''
    null
  else
    'widgets.validation.blank'.t()

validate_email = (t) ->
  return validate_presence(t) or if /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/.test t.toUpperCase()
    null
  else
    'widgets.validation.email'.t()

widgets.VALIDATORS =
  text: validate_presence
  number: validate_presence
  email: validate_email

validate = (input) ->
  $input = $(input)
  $form_group = $input.parents('.form-group').first()
  $controls = $form_group.find('.controls')
  type = $input.attr('type')
  value = $input.val()

  $form_group.removeClass('has-success').removeClass('has-error')
  $form_group.find('.form-control-feedback, .alert').remove()

  if type?
    res = (widgets.VALIDATORS[type] ? validate_presence)(value)
  else
    res = validate_presence(value)

  if res?
    $form_group.addClass('has-error')
    $controls.append("<div class='alert alert-danger'>#{res}</div>")
    $controls.append('<div class="form-control-feedback"><i class="fa fa-times"></i></div>')
    return true
  else
    $form_group.addClass('has-success')
    $controls.append('<div class="form-control-feedback"><i class="fa fa-check"></i></div>')
    return false

widgets.define 'live_validation', (el) ->
  $input = $(el)
  $input.on 'change blur', -> validate(this)

widgets.define 'form_validation', (form) ->
  $form = $(form)
  $form.attr('novalidate', 'novalidate')

  $form.submit (e) ->
    $required =
    $form.find('.has-success, .has-error').removeClass('has-success').removeClass('has-error')
    $form.find('.form-control-feedback, .alert').remove()

    has_errors = false

    $form.find('[required]').each ->
      has_errors = validate(this) or has_errors
      true

    e.stopImmediatePropagation() if has_errors
    not has_errors
