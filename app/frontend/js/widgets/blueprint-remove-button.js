import widgets from 'widjet';
import {asArray, parent} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('blueprint-remove-button', (options={}) => (el) => {
  return new DisposableEvent(el, 'click', () => {
    const target = parent(el, el.dataset.remove);
    const noIndexUpdate = el.hasAttribute('data-no-index-update');

    if (!noIndexUpdate) {
      let index = asArray(target.parentNode.children).indexOf(target);
      let next = target.nextElementSibling;

      while (next != null) {
        if(next.hasAttribute('id')) {
          next.setAttribute('id', next.getAttribute('id')
              .replace(/_\d_/g, `_${index}_`));
        }
        next.innerHTML = next.innerHTML.replace(/_\d_/g, `_${index}_`)
                                       .replace(/\]\[\d\]\[/g, `][${index}][`);
        const withWidgets = asArray(next.querySelectorAll('[class*="-handled"]'));

        withWidgets.forEach((e) => {
          const classesToRemove = e.className.split(/\s+/).filter(c => c.match(/-handled$/));

          for (let c of classesToRemove) {
            e.classList.remove(c);
          }
        });
        index += 1;
        next = next.nextElementSibling;
      }
    }

    const parentNode = target.parentNode;
    target.remove();
    widgets.dispatch(parentNode, 'nested:fieldRemoved');
  });
});
