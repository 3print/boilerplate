import widgets from 'widjet';
import {DisposableEvent} from 'widjet-disposables';
import {parent} from 'widjet-utils';

widgets.define('submit-on-change', (options) => (el) => {
  return new DisposableEvent(el, 'change', (e) => {
    const form = parent(el, 'form');

    form.submit();
  });
});
