widgets.define('collapse', function(el) {
  let $el = $(el);
  return $el.collapse({toggle: false}).on('show.bs.collapse hide.bs.collapse', e => e.preventDefault());
});

widgets.define('collapse_toggle', function(el) {
  let $el = $(el);
  return $el.on('click', function(e) {
    let $target = $($el.data('target'));
    return $target.toggleClass('collapse');
  });
});
