import I18n from '../utils/i18n';
I18n.attachToWindow();

import widgets from 'widjet';
import {parent, getNode} from 'widjet-utils';
import {getTextPreview, getPDFPreview} from 'widjet-file-upload';
import 'nested_form';

import 'widjet-validation';
import 'widjet-select-multiple';
import 'widjet-file-upload';
import {Markdown} from 'widjet-text-editor'

import '../widgets/auto-resize';
import '../widgets/collapse';
// import '../widgets/datepicker';
import '../widgets/field-limit';
import '../widgets/navigation-highlight';
import '../widgets/popover';
import '../widgets/propagate-input-value';
import '../widgets/select';
import '../widgets/settings-editor';
import '../widgets/table-sort-header';

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

// widgets('collapse_toggle', '.open-settings', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('collapse', '.collapse', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('blueprint_button', 'button[data-blueprint]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('blueprint_remove_button', 'button[data-remove]', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('drag_source', '[data-transferable]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('drop_target', '[data-drop]', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('order_list', '.sortable-list', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('order_table', '.sortable', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});

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
});

widgets('table-sort-header', '[data-sort]', {
  on: DEFAULT_EVENTS,
  iconAsc: document.querySelector('.tpl.icon-asc').innerHTML,
  iconDesc: document.querySelector('.tpl.icon-desc').innerHTML,
  iconReset: document.querySelector('.tpl.icon-reset').innerHTML,
});
widgets('settings-editor', '.settings_editor', {on: DEFAULT_EVENTS});
widgets('settings-form', '[data-settings]', {on: DEFAULT_EVENTS});
// widgets('settings_image_uploader', '[data-settings] .file', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('color_button', '.color-icon-wrapper[data-url]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('datepicker-mobile', '.datepicker, .datetimepicker, .timepicker', {on: DEFAULT_EVENTS, if: isMobile, unless: isInTemplate});
// widgets('datepicker', '.datepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('datetimepicker', '.datetimepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('timepicker', '.timepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('filepicker', '.form-group.file', {on: DEFAULT_EVENTS, unless: isInTemplate});
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

const VALIDATION_OPTIONS = {
  on: DEFAULT_EVENTS,
  unless: isInTemplate,
  clean(input) {
    const group = parent(input, '.form-group');
    if(group) {
      group.classList.remove('is-valid');
      group.classList.remove('is-invalid');
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
  onError(input) {
    const group = parent(input, '.form-group');
    if(group) {
      group.classList.add('is-invalid');
    }
    input.classList.add('is-invalid');
  }
}

widgets('live-validation', '[required]', VALIDATION_OPTIONS);
widgets('form-validation', 'form', VALIDATION_OPTIONS);
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
            <i class="fa fa-upload"></i>
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
