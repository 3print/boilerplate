#= require jquery
#= require jquery_ujs
#= require jquery.widget
#= require jquery.YAPSM.min
#= require jquery.pwdcalc
#= require jquery.iframe-transport
#= require utils/jquery.fileupload
#= require bootstrap
#= require moment.min
#= require datepicker
#= require datetimepicker
#= require fastclick
#= require widgets
#= require select2
#= require nested_form
#= require bootstrap-markdown
#= require bootstrap-markdown.fr
#= require utils/markdown
#= require locales
#= require i18n
#= require_tree ./widgets
#= require_tree ./templates

window.DATE_FORMAT = 'YYYY-MM-DD'
window.DATE_DISPLAY_FORMAT = 'DD/MM/YYYY'
window.DATETIME_FORMAT = 'YYYY-MM-DD HH:mm Z'
window.DATETIME_DISPLAY_FORMAT = 'DD/MM/YYYY HH:mm'
window.TIME_FORMAT = 'HH:mm Z'
window.TIME_DISPLAY_FORMAT = 'HH:mm'

DEFAULT_EVENTS = 'load nested:fieldAdded'

is_mobile = -> $(window).width() < 992
is_in_template = (el) -> $(el).parents('.tpl').length > 0
is_mobile_or_in_template = (el) -> is_mobile() or is_in_template(el)

widgets 'navigation_highlight', '.navbar-nav', on: DEFAULT_EVENTS

widgets 'popover', '[data-toggle=popover]', on: DEFAULT_EVENTS, unless: is_in_template

widgets 'auto_resize', 'textarea', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'collapse_toggle', '.open-settings', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'collapse', '.collapse', on: DEFAULT_EVENTS, unless: is_in_template

widgets 'blueprint_button', 'button[data-blueprint]', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'blueprint_remove_button', 'button[data-remove]', on: DEFAULT_EVENTS, unless: is_in_template

widgets 'drag_source', '[data-transferable]', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'drop_target', '[data-drop]', on: DEFAULT_EVENTS, unless: is_in_template

widgets 'order_list', '.sortable-list', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'order_table', '.sortable', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template

widgets 'settings_editor', '.settings_editor', on: DEFAULT_EVENTS
widgets 'settings_form', '[data-settings]', on: DEFAULT_EVENTS
widgets 'settings_image_uploader', '[data-settings] .file', on: DEFAULT_EVENTS, unless: is_in_template

widgets 'boolean', '.boolean', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'color_button', '.color-icon-wrapper[data-url]', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'datepicker_mobile', '.datepicker, .datetimepicker, .timepicker', on: DEFAULT_EVENTS, if: is_mobile, unless: is_in_template
widgets 'datepicker', '.datepicker', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'datetimepicker', '.datetimepicker', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'timepicker', '.timepicker', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'filepicker', '.form-group.file', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'markdown', '[data-editor="markdown"]', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'propagate_input_value', 'input:not(.select2-offscreen):not(.select2-input), select', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'select2', 'select, .select2', on: DEFAULT_EVENTS, unless: is_mobile_or_in_template
widgets 'field_limit', '[data-limit]', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'live_validation', '[required]', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'form_validation', 'form', on: DEFAULT_EVENTS, unless: is_in_template
widgets 'json_form', 'form', on: DEFAULT_EVENTS, unless: is_in_template

I18n.attachToWindow()

old_insertFields = NestedFormEvents::insertFields
NestedFormEvents::insertFields = (content, assoc, link) ->
  if content.indexOf('<tr') isnt -1
    $tr = $(link).closest('tr')
    $(content).insertBefore($tr)
  else if content.indexOf('<li') isnt -1
    $li = $(link).closest('li')
    $(content).insertBefore($li)
  else
    old_insertFields.call(this, content, assoc, link)

$ ->
  FastClick.attach(document.body)

  $('[data-toggle="collapse"]').on 'click', (e) ->
    e.preventDefault()
    $($(this).attr('data-target')).toggleClass('in')

  $('.markdown-help .btn').click (e) ->
    $('.markdown-help').removeClass('visible')
