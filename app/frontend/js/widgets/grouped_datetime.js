
let to_date = m => new Date(m.toISOString());

let computeOffset = function(start, end) {
  if (!end.val()) { return; }

  let start_date = to_date(start.data('DateTimePicker').date());
  let end_date = to_date(end.data('DateTimePicker').date());

  return end_date - start_date;
};

widgets.define('grouped_datetime', function(el) {
  let $el = $(el);
  let $hidden = $el.parent().find(['[type="hidden"]']);
  let $parent = $($el.data('parent-date'));

  let offset = computeOffset($parent, $el);

  $el.on('dp.change', () => offset = computeOffset($parent, $el));

  return $parent.on('dp.change', function() {
    if (offset != null) {
      let end = $parent.data('DateTimePicker').date();
      end.add(offset, 'ms');

      $el.data('DateTimePicker').date(end);

      return offset = computeOffset($parent, $el);
    }
  });
});
