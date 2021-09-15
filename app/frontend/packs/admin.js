import '@rails/ujs';

import I18n from '../js/utils/i18n';
I18n.attachToWindow();

import widgets from 'widjet';
import {asArray, asPair, parent, getNode, merge} from 'widjet-utils';
import {getTextPreview, getPDFPreview} from 'widjet-file-upload';
import 'nested_form';

import 'bootstrap';
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
import '../js/widgets/confirm-action';
import '../js/widgets/flatpickr';

window.DATE_FORMAT = 'YYYY-MM-DD';
window.DATE_DISPLAY_FORMAT = 'DD/MM/YYYY';
window.DATETIME_FORMAT = 'YYYY-MM-DD HH:mm Z';
window.DATETIME_DISPLAY_FORMAT = 'DD/MM/YYYY HH:mm';
window.TIME_FORMAT = 'HH:mm Z';
window.TIME_DISPLAY_FORMAT = 'HH:mm';

const DEFAULT_EVENTS = 'init load page:load turbolinks:load nested:fieldAdded';

const isMobile = () => window.innerWidth < 992;
const isInTemplate = el => parent(el, '.tpl') != null;
const isMobileOrInTemplate = el => isMobile() || isInTemplate(el);

widgets('admin-navigation-highlight', '.sidebar-nav', {on: DEFAULT_EVENTS});
widgets('confirm-action', '[data-confirm', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('submit-on-change', '.submit-on-change', {on: DEFAULT_EVENTS})
widgets('popover', '[data-toggle=popover]', {on: DEFAULT_EVENTS, unless: isInTemplate});

widgets('auto-resize', 'textarea', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('collapse-toggle', '[data-collapse]', {
  collapseClass: 'collapsed',
  on: DEFAULT_EVENTS,
  unless: isInTemplate
});
widgets('collapse', '[data-bs-toggle="collapse"]', {
  triggerClass: 'collapsed',
  collapseClass: 'show',
  collapsable: '.collapse',
  on: DEFAULT_EVENTS,
  unless: isInTemplate
});

widgets('select', 'select.form-control:not([multiple])', {on: DEFAULT_EVENTS})
widgets('select-multiple', 'select[multiple]', {
  on: DEFAULT_EVENTS,
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
})

widgets('order-table', '.sortable', {on: DEFAULT_EVENTS});

widgets('table-sort-header', '[data-sort]', {
  on: DEFAULT_EVENTS,
  iconAsc: document.querySelector('.tpl.icon-asc').innerHTML,
  iconDesc: document.querySelector('.tpl.icon-desc').innerHTML,
  iconReset: document.querySelector('.tpl.icon-reset').innerHTML,
});
widgets('settings-editor', '.settings_editor', {on: DEFAULT_EVENTS});
widgets('settings-form', '[data-settings]', {on: DEFAULT_EVENTS});

widgets('flatpickr', '.datetimepicker', {
  on: DEFAULT_EVENTS,
  enableTime: true,
  altInput: true,
  altFormat: 'l d F Y à H:i',
  dateFormat: 'Z',
});

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
widgets('propagate-input-value', 'input:not(.select2-offscreen):not(.select2-input), select', {on: DEFAULT_EVENTS, unless: isInTemplate});

widgets('field-limit', '[data-limit]', {on: DEFAULT_EVENTS, unless: isInTemplate});

widgets('live-validation', 'input, select, textarea', merge({
  on: DEFAULT_EVENTS,
  unless: isInTemplate,
}, VALIDATION_OPTIONS));
widgets('form-validation', 'form', merge({
  on: DEFAULT_EVENTS,
  unless: isInTemplate,
}, VALIDATION_OPTIONS));

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

widgets('file-versions', '.with-regions input[type="file"]', {
  on: 'load',
  containerSelector: '.file-input-container',
  initialValueSelector: '.current-value img',
  previewSelector: '.new-value img',
  versionsProvider,
  versionBoxesProvider,
  onVersionsChange,
  getVersion,
});

widgets('file-preview', 'input[type="file"]', {
  on: DEFAULT_EVENTS,
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
});

// widgets('json_form', 'form', {on: DEFAULT_EVENTS, unless: isInTemplate});

// hljs.initHighlightingOnLoad();

// $(function() {
//   FastClick.attach(document.body);

//   return $('[data-toggle="collapse"]').on('click', function(e) {
//     e.preventDefault();
//     return $($(this).attr('data-target')).toggleClass('in');
//   });
// });
