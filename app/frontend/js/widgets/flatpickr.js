import flatpickr from 'flatpickr';
import widgets from 'widjet';
import {French} from 'flatpickr/dist/l10n/fr.js';
import {merge} from 'widjet-utils';

widgets.define('flatpickr', (options) => (el) => {
  requestAnimationFrame(() => {
    if(!el.hasAttribute('name')) { return; }
    const pickr = flatpickr(el, merge(options, {
      locale: French,
    }));
    pickr.altInput.classList.add('flatpickr-trigger');
  });
});
