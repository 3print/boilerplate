import widgets from 'widjet';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('auto-resize', (options) => (el) => {
  function resize() {
    el.style.height = '0px';
    return el.style.height = `${el.scrollHeight}px`;
  };

  requestAnimationFrame(() => resize(el));

  return new DisposableEvent(el, 'input', resize);
});
