import widgets from 'widjet';
import {getNode} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

widgets.define('remote-form', (options) => (el) => {
  const method = el.method;
  const action = el.action;

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

  return new DisposableEvent(el, 'submit', (e) => {
    e.preventDefault();
    e.stopPropagation();

    const handleSuccess = window[el.dataset.handleSuccess];
    const handleError = window[el.dataset.handleError];

    const alert = el.parentNode.querySelector('.alert')
    if(alert) { alert.remove(); }

    el.classList.add('loading');

    const formData = new FormData(el);
    const body = {};

    for(let e of formData.entries()) {
      body[e[0]] = e[1] == '1';
    }

    const options = {
      method,
      body: JSON.stringify(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
    };

    return fetch(action, options)
    .then((res) => res.json())
    .then((res) => {
      handleSuccess && handleSuccess(res);
      el.classList.remove('loading');
    })
    .catch((err) => handleError && handleError(err));
  });
});
