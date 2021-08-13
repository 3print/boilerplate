let is_json = s => s.match(/^\{|^\[/);
let is_boolean_field = function(field) {
  let type = field.attr('type');
  return type === 'checkbox';
};

let is_radio_field = function(field) {
  let type = field.attr('type');
  return type === 'radio';
};

var build_fields = function(o, input_name, $input) {
  if (typeof o === 'object') {
    if (Array.isArray(o)) {
      return o.forEach((v, i) => build_fields(v, `${input_name}[${i}]`, $input));
    } else {
      return (() => {
        let result = [];
        for (let k in o) {
          let v = o[k];
          result.push(build_fields(v, `${input_name}[${k}]`, $input));
        }
        return result;
      })();
    }
  } else {
    let $new_input = $(`<input type='hidden' name='${input_name}'></input>`);
    $new_input.val(o === 'undefined' ? '' : o);
    return $input.after($new_input);
  }
};

widgets.define('json_form', function(form) {
  let $form = $(form);

  return $form.on('submit', function() {
    let $fields = $form.find('input[name]');
    return $fields.each(function() {
      let $input = $(this);

      if (is_radio_field($input)) { return; }

      let input_name = $input.attr('name');

      if (is_boolean_field($input)) {
        build_fields($input.is(':checked'), input_name, $input);

        return $input.remove();
      } else {
        let value = $input.val();
        if (is_json(value)) {
          value = JSON.parse(value);

          build_fields(value, input_name, $input);

          return $input.remove();
        }
      }
    });
  });
});

    // console.log JSON.stringify($form.serializeArray(), null, 2)
    // return false
