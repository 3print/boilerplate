import widgets from 'widjet';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('confirm-action', (options) => (el) => {
  return new DisposableEvent(el, 'click', (e) => {
    if(!confirm(el.dataset.confirm)) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
    }
  });
});
