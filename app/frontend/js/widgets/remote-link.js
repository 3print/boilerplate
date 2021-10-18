import widgets from 'widjet';
import {getNode} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('remote-link', (options) => (el) => {
  const method = el.dataset.method;
  const url = el.getAttribute('href');
  const handleSuccess = window[el.dataset.handleSuccess];
  const handleError = window[el.dataset.handleError];

  const listener = (data) => {
    typeof handle == 'function' && handle(data, el);
  }

  const onError = (data) => {
    if (data.errors != null) {
      for (let k in data.errors) {
        const v = data.errors[k];
        el.parentNode.insertBefore(getNode(`\
<span class='alert alert-danger alert-dismissible'>
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  ${v}
</span>\
`));
      }
    }
  };

  return new DisposableEvent(el, 'click', (e) => {
    e.preventDefault();
    e.stopPropagation();

    const alert = el.parentNode.querySelector('.alert')
    if(alert) { alert.remove(); }

    el.classList.add('loading');

    return fetch(url, {
      method,
      success: listener,
    })
    .then((res) => res.json())
    .then((res) => {
      handleSuccess(res);
      el.classList.remove('loading');
    })
    .catch(handleError);
  });
});
