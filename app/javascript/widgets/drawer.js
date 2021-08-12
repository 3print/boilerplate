widgets.define('drawer', function(trigger, options) {
  let overlay = document.querySelector('.drawer-overlay');

  let openDrawer = () => document.body.classList.add('drawer-open');

  let closeDrawer = function() {
    document.body.classList.remove('drawer-open');
    __guard__(document.querySelector('.subdrawer.visible'), x => x.classList.remove('visible'));
    __guard__(document.querySelector('[data-toggle="subdrawer"].open'), x1 => x1.classList.remove('open'));
    return setTimeout(() => document.querySelector('.drawer').classList.remove('subdrawer-open')
    , 300);
  };

  overlay.addEventListener('click', () => closeDrawer());

  return trigger.addEventListener('click', function() {
    if (document.body.classList.contains('drawer-open')) {
      return closeDrawer();
    } else {
      return openDrawer();
    }
  });
});

widgets.define('drawer_menu', function(menuLink, options) {
  let target = document.querySelector(menuLink.getAttribute('data-target'));
  let closeButton = target.querySelector('button');
  closeButton.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    document.querySelector('.drawer').classList.remove('subdrawer-open');
    __guard__(document.querySelector('.subdrawer.visible'), x => x.classList.remove('visible'));
    return __guard__(document.querySelector('[data-toggle="subdrawer"].open'), x1 => x1.classList.remove('open'));
  });

  return menuLink.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    __guard__(document.querySelector('.subdrawer.visible'), x => x.classList.remove('visible'));
    __guard__(document.querySelector('[data-toggle="subdrawer"].open'), x1 => x1.classList.remove('open'));

    document.querySelector('.drawer').classList.add('subdrawer-open');
    target.classList.add('visible');
    return menuLink.classList.add('open');
  });
});

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}