import widgets from 'widjet';
import {getNode} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('remote-link', (options) => (el) => {
  const method = el.dataset.method;
  const body = el.dataset.body ? el.dataset.body : {};
  const url = el.getAttribute('href');

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

    const handleSuccess = window[el.dataset.handleSuccess];
    const handleError = window[el.dataset.handleError];

    const alert = el.parentNode.querySelector('.alert')
    if(alert) { alert.remove(); }

    el.classList.add('loading');

    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
    };

    if(body) {
      options.body = body
    }

    return fetch(url, options)
    .then((res) => res.json())
    .then((res) => {
      handleSuccess && handleSuccess(res);
      el.classList.remove('loading');
    })
    .catch((err) => handleError && handleError(err));
  });
});
