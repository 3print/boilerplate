widgets.define('navigation_highlight', function(nav) {

  if (document.body.classList.length) {
    let current_controller = document.body.className.split(' ').map(s => `.${s}`).join(', ');

    let active = nav.querySelector(current_controller);
    if (active != null) {
      let parent;
      active.classList.add('active');
      nav.classList.add('has-active');

      if ((parent = active.parentNode.parentNode).nodeName === 'LI') {
        return parent.classList.add('active');
      }
    }
  }
});
