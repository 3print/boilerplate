import {always, parent, getNode, compose, detachNode} from 'widjet-utils';
import {inputPredicate, attributePredicate} from 'widjet-validation/lib/utils';
import {validatePresence, nativeValidation} from 'widjet-validation/lib/validators';

const numberPredicate = inputPredicate('number');
const filePredicate = inputPredicate('file');
const requiredPredicate = (i) => i.classList.contains('required') || i.hasAttribute('required');

export default {
  resolvers: [
    [numberPredicate, i => i.value],
  ],
  validators: [
    [compose(numberPredicate, requiredPredicate), validatePresence],
    [compose(filePredicate, requiredPredicate), validatePresence],
    [requiredPredicate, (i18n,v,i) => validatePresence(i18n,v,i) || nativeValidation(i18n,v,i)],
  ],
  clean(input) {
    const group = parent(input, '.form-group');
    if(group) {
      group.classList.remove('is-valid');
      group.classList.remove('is-invalid');

      const prevError = group.querySelector('.invalid-feedback');
      if (prevError) { detachNode(prevError); }
    }
    input.classList.remove('is-valid');
    input.classList.remove('is-invalid');
  },
  onSuccess(input) {
    const group = parent(input, '.form-group');
    if(group) {
      group.classList.add('is-valid');
    }
    input.classList.add('is-valid');
  },
  onError(input, res) {
    const group = parent(input, '.form-group');
    if(group) {
      group.classList.add('is-invalid');

      const prevError = group.querySelector('.invalid-feedback');
      if (prevError) { detachNode(prevError); }

      const error = getNode(`<div class='invalid-feedback d-block'>${`widgets.validation.${res}`.t()}</div>`);
      group.appendChild(error);
    }
    input.classList.add('is-invalid');
  }
}
