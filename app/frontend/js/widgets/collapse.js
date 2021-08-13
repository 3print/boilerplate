import widgets from 'widjet';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('collapse-toggle', (options) => (el) => {
  return new DisposableEvent(el, 'click', (e) => {
    e.preventDefault();
    const target = document.querySelector(el.dataset.collapse);
    if(target) {
      target.classList.toggle(options.collapseClass);
    }
  });
});

widgets.define('collapse', (options) => (el) => {
  return new DisposableEvent(el, 'click', (e) => {
    e.preventDefault();
    const target = el.parentNode.querySelector(options.collapsable);
    el.classList.toggle(options.triggerClass);
    if(target) {
      target.classList.toggle(options.collapseClass);
    }
  });
});

