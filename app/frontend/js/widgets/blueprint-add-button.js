import widgets from 'widjet';
import {getNodes, parent} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('blueprint-add-button', (options) => (el) => {
  const blueprint = el.dataset.blueprint || document.querySelector(el.dataset.blueprintSelector).dataset.blueprint;
  const blueprintContext = el.dataset.blueprintContext || 'div';
  const newIndex = options.newIndex || ((t) => t.children.length);
  const target = parent(el, el.dataset.target);

  const insertionPoint = el.dataset.insertBefore && parent(el, el.dataset.insertBefore);

  return new DisposableEvent(el, 'click', () => {
    const index = newIndex(target);
    const content = getNodes(blueprint.replace(/\{index\}/gm, index), blueprintContext);
    content.forEach(n => target.insertBefore(n, insertionPoint));
    widgets.dispatch(target, 'nested:fieldAdded');
  });
});
