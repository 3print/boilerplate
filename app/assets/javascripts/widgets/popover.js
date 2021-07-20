widgets.define('popover', function(el) {
  let $el = $(el);
  if ($(window).width() < 992) { $el.attr('data-trigger', 'click'); }
  $el.popover();
  return $el.on('click', () =>
    setTimeout(() =>
      $('body').on('click', function() {
        $('body').off('click');
        return $el.popover('hide');
      })
    
    , 500)
  );
});
