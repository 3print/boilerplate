import widgets from 'widjet';

widgets.define('popover', (options) => (el) => {
  let $el = $(el);
  if (window.innerWidth < 992) {
    el.setAttribute('data-trigger', 'click');
  }
  $el.popover();
  return $el.on('click', () =>
    requestAnimationFrame(() =>
      $('body').on('click', function() {
        $('body').off('click');
        return $el.popover('hide');
      })
    
    , 500)
  );
});
