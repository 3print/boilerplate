import widgets from 'widjet';
import {parent} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('propagate-input-value', (options) => (el) => {
  if (el.checked || el.type == 'radio') { propagate(); }

  return new DisposableEvent(el, 'change', () => propagate());

  function propagate() {
    if (['radio', 'checkbox'].includes(el.type)) {
      parent(el, '.form-group').setAttribute('data-value', el.checked);
    } else {
      parent(el, '.form-group').setAttribute('data-value', el.value);
    }
  };
});
