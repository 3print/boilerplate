import Rails from '@rails/ujs';
Rails.start();

import I18n from '../js/utils/i18n';
I18n.attachToWindow();

import FastClick from '../../../vendor/assets/javascripts/fastclick';
FastClick.attach(document.body);

import widgets from 'widjet';
import {asArray, asPair, parent, getNode, merge} from 'widjet-utils';
import {getTextPreview, getPDFPreview} from 'widjet-file-upload';
import s3DirectUpload from '../js/utils/s3-direct-upload';
import '../../../vendor/assets/javascripts/nested_form';

// Importing 'bootstrap' in the context of webpack will lead
// to include the esm version, which does not initialize
// bootstrap's components. Importing this version will do.
import 'bootstrap/dist/js/bootstrap.js';
import 'widjet-validation';
import 'widjet-select-multiple';
import 'widjet-file-upload';
import {Markdown} from 'widjet-text-editor'

import VALIDATION_OPTIONS from '../js/widgets/validation';
import '../js/widgets/auto-resize';
import '../js/widgets/collapse';
import '../js/widgets/field-limit';
import '../js/widgets/navigation-highlight';
import '../js/widgets/popover';
import '../js/widgets/propagate-input-value';
import '../js/widgets/select';
import '../js/widgets/settings-editor';
import '../js/widgets/table-sort-header';
import '../js/widgets/order-table';
import '../js/widgets/submit-on-change';
import '../js/widgets/flatpickr';
import '../js/widgets/lazy-image';
import '../js/widgets/blueprint-add-button';
import '../js/widgets/blueprint-remove-button';

window.DATE_FORMAT = 'YYYY-MM-DD';
window.DATE_DISPLAY_FORMAT = 'DD/MM/YYYY';
window.DATETIME_FORMAT = 'YYYY-MM-DD HH:mm Z';
window.DATETIME_DISPLAY_FORMAT = 'DD/MM/YYYY HH:mm';
window.TIME_FORMAT = 'HH:mm Z';
window.TIME_DISPLAY_FORMAT = 'HH:mm';

const DEFAULT_EVENTS = 'init load page:load turbolinks:load nested:fieldAdded';
const DEFAULT_CONFIG = {
  on: DEFAULT_EVENTS,
  unless: isInTemplate,
}

const isMobile = () => window.innerWidth < 992;
const isInTemplate = el => parent(el, '.tpl') != null;
const isMobileOrInTemplate = el => isMobile() || isInTemplate(el);

widgets('admin-navigation-highlight', '.sidebar-nav', DEFAULT_CONFIG);
widgets('submit-on-change', '.submit-on-change', DEFAULT_CONFIG);
widgets('popover', '[data-toggle=popover]', DEFAULT_CONFIG);

widgets('lazy-image', '[data-lazy]', DEFAULT_CONFIG);
widgets('auto-resize', 'textarea', DEFAULT_CONFIG);
widgets('collapse-toggle', '[data-collapse]', merge(DEFAULT_CONFIG, {
  collapseClass: 'collapsed',
}));
widgets('blueprint-add-button', '[data-blueprint]', merge(DEFAULT_CONFIG, {
  newIndex: (t) => t.children.length - 1,
}));
widgets('blueprint-remove-button', '[data-remove]', DEFAULT_CONFIG);

widgets('select', 'select.form-control:not([multiple])', DEFAULT_CONFIG)
widgets('select-multiple', 'select[multiple]', merge(DEFAULT_CONFIG, {
  wrapperClass: 'select-multiple form-control',
  itemClass: 'option badge bg-light text-dark',
  formatValue: (option) => {
    const div = document.createElement('div');
    div.classList.add('option');
    div.classList.add('badge');
    div.classList.add('bg-light');
    div.classList.add('text-dark');
    div.setAttribute('data-value', option.value);
    div.innerHTML = `
      <span class="label">${option.textContent}</span>
      <button type="button" class="close" tabindex="-1">
        ${document.querySelector('.tpl.icon-close').innerHTML}
      </button>
    `;

    return div;
  }
}));

widgets('order-table', '.sortable', DEFAULT_CONFIG);

widgets('table-sort-header', '[data-sort]', merge(DEFAULT_CONFIG, {
  iconAsc: document.querySelector('.tpl.icon-asc').innerHTML,
  iconDesc: document.querySelector('.tpl.icon-desc').innerHTML,
  iconReset: document.querySelector('.tpl.icon-reset').innerHTML,
}));
widgets('settings-editor', '.settings_editor', DEFAULT_CONFIG);
widgets('settings-form', '[data-settings]', DEFAULT_CONFIG);

widgets('flatpickr', '.datetimepicker', merge(DEFAULT_CONFIG, {
  enableTime: true,
  altInput: true,
  altFormat: 'l d F Y à H:i',
  dateFormat: 'Z',
}));

widgets('text-editor', '.form-group.markdown', {
  on: DEFAULT_EVENTS,
  unless: isMobileOrInTemplate,

  // functions to wrap a selection in markdown blocks
  blockquote: Markdown.blockquote,
  codeBlock: Markdown.codeBlock,
  unorderedList: Markdown.unorderedList,
  orderedList: Markdown.orderedList,

  // function to increment automatically the list bullet in ordered lists
  repeatOrderedList: Markdown.repeatOrderedList
});
widgets('propagate-input-value', 'input:not(.select2-offscreen):not(.select2-input), select', DEFAULT_CONFIG);

widgets('field-limit', '[data-limit]', DEFAULT_CONFIG);

widgets('live-validation', 'input, select, textarea', merge({
  events: 'input change blur',
  inputBuffer: 500,
}, merge(DEFAULT_CONFIG, VALIDATION_OPTIONS)));
widgets('form-validation', 'form', merge(DEFAULT_CONFIG, VALIDATION_OPTIONS));

const versionSiblings = (el) =>
  asArray(parent(el, '.controls').querySelectorAll('input[data-size]'));

const jsonReducer = (attr) => (m, i) => {
  m[i.getAttribute('data-version-name')] = JSON.parse(i.getAttribute(attr));
  return m;
}

const versionsProvider = (el) =>
  versionSiblings(el).reduce(jsonReducer('data-size'), {});

const versionBoxesProvider = (el) =>
  versionSiblings(el).reduce(jsonReducer('value'), {});

const onVersionsChange = (el, versions) => {
  const container = parent(el, '.controls');
  asPair(versions).forEach(([name, box]) => {
    if (box) {
      container.querySelector(`input[data-version-name="${name}"]`).value = JSON.stringify(box);
    }
  });
}

const getVersion = ((img, version) => {
  const canvas = version.getVersion(img);
  const div = getNode(`
    <div class="version">
      <button type="button" tabindex="-1" class="btn btn-outline-primary"><span>${'actions.edit'.t()}</span></button>
      <div class="version-meta">
        <span class="version-name">${version.name}</span>
        <span class="version-size">${version.size.join('x')}</span>
      </div>
    </div>
  `);
  div.appendChild(canvas, div.firstChild);
  return div;
});

widgets('file-versions', '.with-regions input[type="file"]', merge(DEFAULT_CONFIG, {
  containerSelector: '.file-input-container',
  initialValueSelector: '.current-value img',
  previewSelector: '.new-value img',
  versionsProvider,
  versionBoxesProvider,
  onVersionsChange,
  getVersion,
}));

widgets('file-preview', 'input[type="file"]', merge(DEFAULT_CONFIG, {
  previewers: [
    [o => o.file.type === 'application/pdf', getPDFPreview],
    [o => o.file.type === 'text/plain', getTextPreview]
  ],
  nameMetaSelector: '.new-value .name',
  wrap: (input) => {
    const wrapper = getNode(`
      <div class="new-value">
        <div class='file-container'>
          <label for="${input.id}"></label>
          <div class="preview"></div>
          <div class="file-placeholder">
            ${document.querySelector('.tpl.icon-upload').innerHTML}
            <span>${'widgets.file_preview.label'.t()}</span>
          </div>
          <button class="btn btn-outline-danger btn-sm btn-icon remove-file" type="button" tabindex="-1">${document.querySelector('.tpl.icon-close').innerHTML}</button>
        </div>
        <progress min="0" max="100"></progress>
        <div class="name"></div>
        <div class="meta">
          <div class="mime"></div>
          <div class="size"></div>
          <div class="dimensions"></div>
        </div>
      </div>
    `);

    const label = wrapper.querySelector('label');
    label.parentNode.insertBefore(input, label);
    return wrapper;
  },
}));

const uploader = s3DirectUpload({
  s3: {
    path: '/uploads/',
  },
  signing: {
    url: '/api/s3/sign',
    method: 'GET',
  },
});

widgets('file-upload', 'input.direct-upload[type="file"][name]', merge(DEFAULT_CONFIG, {
  upload: uploader,
}));
widgets('file-upload', 'input.direct-upload[type="file"][data-name]', merge(DEFAULT_CONFIG, {
  nameAttribute: 'data-name',
  upload: uploader,
}));
