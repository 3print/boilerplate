//= require jquery
//= require jquery_ujs
//= #require jquery.widget
//= #require jquery.iframe-transport
//= #require utils/jquery.fileupload
//= require bootstrap
//= require moment.min
//= require datetimepicker
//= #require fastclick
//= require bootstrap-markdown
//= require bootstrap-markdown.fr
//= #require highlight.pack
//= #require utils/markdown
//= #require_tree ./widgets
//= require_tree ./templates

import I18n from './i18n';
I18n.attachToWindow();

import widgets from 'widjet';
import {parent} from 'widjet-utils';
import 'nested_form';

import 'widjet-validation';
import 'widjet-select-multiple';
import 'widjet-file-upload';

import './widgets/datepicker';
import './widgets/markdown';
import './widgets/field-limit';
import './widgets/select';
import './widgets/navigation-highlight';
import './widgets/auto-resize';
import './widgets/settings-editor';
import './widgets/propagate-input-value';
import './widgets/popover';

window.DATE_FORMAT = 'YYYY-MM-DD';
window.DATE_DISPLAY_FORMAT = 'DD/MM/YYYY';
window.DATETIME_FORMAT = 'YYYY-MM-DD HH:mm Z';
window.DATETIME_DISPLAY_FORMAT = 'DD/MM/YYYY HH:mm';
window.TIME_FORMAT = 'HH:mm Z';
window.TIME_DISPLAY_FORMAT = 'HH:mm';

const DEFAULT_EVENTS = 'load nested:fieldAdded';

const isMobile = () => window.innerWidth < 992;
const isInTemplate = el => parent(el, '.tpl') != null;
const isMobileOrInTemplate = el => isMobile() || isInTemplate(el);

widgets('navigation-highlight', '.navbar-nav', {on: DEFAULT_EVENTS});

widgets('popover', '[data-toggle=popover]', {on: DEFAULT_EVENTS, unless: isInTemplate});

widgets('auto-resize', 'textarea', {on: DEFAULT_EVENTS, unless: isInTemplate});
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
})

widgets('settings-editor', '.settings_editor', {on: DEFAULT_EVENTS});
widgets('settings-form', '[data-settings]', {on: DEFAULT_EVENTS});
// widgets('settings_image_uploader', '[data-settings] .file', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('color_button', '.color-icon-wrapper[data-url]', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('datepicker-mobile', '.datepicker, .datetimepicker, .timepicker', {on: DEFAULT_EVENTS, if: isMobile, unless: isInTemplate});
widgets('datepicker', '.datepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
widgets('datetimepicker', '.datetimepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
widgets('timepicker', '.timepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('filepicker', '.form-group.file', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('markdown', '[data-editor="markdown"]', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
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
widgets('file-preview', 'input[type="file"]', {on: DEFAULT_EVENTS});

// widgets('json_form', 'form', {on: DEFAULT_EVENTS, unless: isInTemplate});

// hljs.initHighlightingOnLoad();

// $(function() {
//   FastClick.attach(document.body);

//   return $('[data-toggle="collapse"]').on('click', function(e) {
//     e.preventDefault();
//     return $($(this).attr('data-target')).toggleClass('in');
//   });
// });
