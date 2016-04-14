is_json = (s) -> s.match /^\{|^\[/

build_fields = (o, input_name, $input) ->
  if typeof o is 'object'
    if Array.isArray(o)
      o.forEach (v, i) ->
        build_fields(v, "#{input_name}[#{i}]", $input)
    else
      for k,v of o
        build_fields(v, "#{input_name}[#{k}]", $input)
  else
    $new_input = $("<input type='hidden' name='#{input_name}' value='#{if o is 'undefined' then '' else o}'></input>")
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

    # console.log JSON.stringify($form.serializeArray(), null, 2)
    # return false
