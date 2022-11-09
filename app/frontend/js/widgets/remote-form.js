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
      const path = pathFromFormData(e[0]);
      const isArray = formDataIsArray(e[0]);

      setAtPath(body, path, isArray ? [e[1]] : e[1]);
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
    .then((res) => {
      if (res.status < 300) {
        return res.json();
      } else {
        return res.json().then(data => {
          console.log(data);
          throw new Error(data.message);
        });
      }
    })
    .then((res) => {
      handleSuccess && handleSuccess(res, el);
      el.classList.remove('loading');
    })
    .catch((err) => handleError && handleError(err, el));
  });

  function pathFromFormData(name) {
    return name.replace(/\]$/, '').split(/\]?\[/).filter(s => s != '');
  }

  function formDataIsArray(name) {
    return /\[\]$/.test(name);
  }

  function setAtPath(object, path, value) {
    path.forEach((n,i) => {
      if(i < path.length - 1) {
        object[n] ||= {};

        object = object[n]
      } else {
        if(Array.isArray(object[n]) && Array.isArray(value)) {
          object[n] = object[n].concat(value).filter(v => v != '');
        } else {
          object[n] = value;
        }
      }
    });
  }
});
