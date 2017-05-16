is_json = (s) -> s.match /^\{|^\[/
is_boolean_field = (field) ->
  type = field.attr('type')
  type is 'checkbox'

is_radio_field = (field) ->
  type = field.attr('type')
  type is 'radio'

build_fields = (o, input_name, $input) ->
  if typeof o is 'object'
    if Array.isArray(o)
      o.forEach (v, i) ->
        build_fields(v, "#{input_name}[#{i}]", $input)
    else
      for k,v of o
        build_fields(v, "#{input_name}[#{k}]", $input)
  else
    $new_input = $("<input type='hidden' name='#{input_name}'></input>")
    $new_input.val(if o is 'undefined' then '' else o)
    $input.after($new_input)

widgets.define 'json_form', (form) ->
  $form = $(form)

  $form.on 'submit', ->
    $fields = $form.find('input[name]')
    $fields.each ->
      $input = $(this)

      return if is_radio_field($input)

      input_name = $input.attr('name')

      if is_boolean_field($input)
        build_fields($input.is(':checked'), input_name, $input)

        $input.remove()
      else
        value = $input.val()
        if is_json(value)
          value = JSON.parse(value)

          build_fields(value, input_name, $input)

          $input.remove()
