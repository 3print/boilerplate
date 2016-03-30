{is_json} = SettingsEditor.Utils

build_fields = (o, input_name, $input) ->
  for k,v of o
    if typeof v is 'object'
      if Array.isArray(v)
        v.forEach (vv) ->
          $new_input = $("<input type='hidden' name='#{input_name}[#{k}][]' value='#{vv}'></input>")
          $input.after($new_input)

      else
        build_fields(v, "#{input_name}[#{k}]", $input)
    else
      $new_input = $("<input type='hidden' name='#{input_name}[#{k}]' value='#{v}'></input>")
      $input.after($new_input)

widgets.define 'json_form', (form) ->
  $form = $(form)

  $form.on 'submit', ->
    $fields = $form.find('input[name]')
    $fields.each ->
      $input = $(this)
      value = $input.val()
      input_name = $input.attr('name')
      if is_json(value)
        value = JSON.parse(value)

        build_fields(value, input_name, $input)

        $input.remove()
