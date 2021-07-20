widgets.define('propagate_input_value', function(el) {
  let $el = $(el);
  let propagate = function() {
    if ($el.is('[type=radio], [type=checkbox]')) {
      return $el.parents('.form-group').attr('data-value', $el[0].checked);
    } else {
      return $el.parents('.form-group').attr('data-value', $el.val());
    }
  };

  if ($el.is('[type=radio]:checked')) { propagate(); }
  if (!$el.is('[type=radio]')) { propagate(); }
  return $el.on('change', () => propagate());
});
