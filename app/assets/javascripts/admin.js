//= require jquery
//= require jquery_ujs
//= #require jquery.widget
//= #require jquery.iframe-transport
//= #require utils/jquery.fileupload
//= require bootstrap
//= require moment.min
//= require datetimepicker
//= #require fastclick
//= require select2
//= require bootstrap-markdown
//= require bootstrap-markdown.fr
//= #require highlight.pack
//= #require utils/markdown
//= #require_tree ./widgets
//= #require_tree ./templates

import I18n from './i18n';
import widgets from 'widjet';
import {parent} from 'widjet-utils';
import 'nested_form';

import './widgets/datepicker';
import './widgets/select2';
import './widgets/markdown';

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

// widgets('navigation_highlight', '.navbar-nav', {on: DEFAULT_EVENTS});

// widgets('popover', '[data-toggle=popover]', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('auto_resize', 'textarea', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('collapse_toggle', '.open-settings', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('collapse', '.collapse', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('blueprint_button', 'button[data-blueprint]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('blueprint_remove_button', 'button[data-remove]', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('drag_source', '[data-transferable]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('drop_target', '[data-drop]', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('order_list', '.sortable-list', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('order_table', '.sortable', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});

// widgets('settings_editor', '.settings_editor', {on: DEFAULT_EVENTS});
// widgets('settings_form', '[data-settings]', {on: DEFAULT_EVENTS});
// widgets('settings_image_uploader', '[data-settings] .file', {on: DEFAULT_EVENTS, unless: isInTemplate});

// widgets('color_button', '.color-icon-wrapper[data-url]', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('datepicker_mobile', '.datepicker, .datetimepicker, .timepicker', {on: DEFAULT_EVENTS, if: isMobile, unless: isInTemplate});
widgets('datepicker', '.datepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
widgets('datetimepicker', '.datetimepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
widgets('timepicker', '.timepicker', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('filepicker', '.form-group.file', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('markdown', '[data-editor="markdown"]', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('propagate_input_value', 'input:not(.select2-offscreen):not(.select2-input), select', {on: DEFAULT_EVENTS, unless: isInTemplate});
widgets('select2', 'select, .select2', {on: DEFAULT_EVENTS, unless: isMobileOrInTemplate});
// widgets('field_limit', '[data-limit]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('live_validation', '[required]', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('form_validation', 'form', {on: DEFAULT_EVENTS, unless: isInTemplate});
// widgets('json_form', 'form', {on: DEFAULT_EVENTS, unless: isInTemplate});

I18n.attachToWindow();

// hljs.initHighlightingOnLoad();

// $(function() {
//   FastClick.attach(document.body);

//   return $('[data-toggle="collapse"]').on('click', function(e) {
//     e.preventDefault();
//     return $($(this).attr('data-target')).toggleClass('in');
//   });
// });