import widgets from 'widjet';

widgets.define('navigation-highlight', (options) => (nav, widget) => {
  if (document.body.classList.length) {
    const current_controller = document.body.className.split(' ').map(s => `.${s}`).join(', ');

    let active = nav.querySelector(current_controller);
    if (active != null) {
      active.querySelector('a').classList.add('active');
      nav.classList.add('has-active');

      const parent = active.parentNode.parentNode;
      if (parent.nodeName === 'LI') {
        return parent.querySelector('a').classList.add('active');
      }
    }
  }
});
