import widgets from 'widjet';

widgets.define('popover', (options) => (el) => {
  let $el = $(el);
  if (window.innerWidth < 992) {
    el.setAttribute('data-trigger', 'click');
  }

  $el.popover();
  $el.on('click', () =>
    requestAnimationFrame(() =>
      $('body').on('click', () => {
        $('body').off('click');
        $el.popover('hide');
      })
    
    , 500)
  );
});
