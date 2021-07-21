import widgets from 'widjet';
import {CompositeDisposable, DisposableEvent} from 'widjet-disposables';

widgets.define('field_limit', (option) => (el) => {
  const limit = Number(el.getAttribute('data-limit'));

  if ((limit == null) || (limit === 0)) { return; }

  const result = document.createElement('div');

  function check() {
    result.textContent = 'widgets.field_limit.remaining'.t({
      count: limit - el.value.length
    });

    if (el.value.length > limit) {
      return result.className = 'text-danger';
    } else {
      return result.className = 'text-success';
    }
  };

  el.parentNode.appendChild(result);

  const composite = new CompositeDisposable([
    new DisposableEvent(el, 'input', check),
    new DisposableEvent(el, 'change', check)
  ]);

  check();

  return composite;
});
