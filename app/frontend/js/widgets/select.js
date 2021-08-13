
import widgets from 'widjet';
import {asArray, parent} from 'widjet-utils';

widgets.define('select', (options) => (el, widget) => {
  const wrapper = document.createElement('div');
  wrapper.className = 'select form-control';

  el.classList.remove('form-control');

  el.parentNode.insertBefore(wrapper, el);
  wrapper.appendChild(el);
});
