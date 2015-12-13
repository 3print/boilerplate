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

DEFAULT_EVENTS = 'load nested:fieldAdded'

is_mobile = -> $(window).width() < 992

widgets 'auto_resize', 'textarea', on: DEFAULT_EVENTS
widgets 'blueprint_button', 'button[data-blueprint]', on: DEFAULT_EVENTS
widgets 'blueprint_remove_button', 'button[data-remove]', on: DEFAULT_EVENTS
widgets 'boolean', '.boolean', on: DEFAULT_EVENTS
widgets 'collapse_toggle', '.open-settings', on: DEFAULT_EVENTS
widgets 'collapse', '.collapse', on: DEFAULT_EVENTS
widgets 'color_button', '.color-icon-wrapper[data-url]', on: DEFAULT_EVENTS
widgets 'datepicker_mobile', '.datepicker', on: DEFAULT_EVENTS, if: is_mobile
widgets 'datepicker', '.datepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datetimepicker', '.datetimepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'drag_source', '[data-transferable]', on: DEFAULT_EVENTS
widgets 'drop_target', '[data-drop]', on: DEFAULT_EVENTS
widgets 'filepicker', '.form-group.file', on: DEFAULT_EVENTS
widgets 'markdown', '[data-editor="markdown"]', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'navigation_highlight', '.navbar-nav', on: DEFAULT_EVENTS
widgets 'order_list', '.sortable-list', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'order_table', '.sortable', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'popover', '[data-toggle=popover]', on: DEFAULT_EVENTS
widgets 'propagate_input_value', 'input, select', on: DEFAULT_EVENTS
widgets 'select_url', '[data-toggle=url]', on: DEFAULT_EVENTS
widgets 'select2', 'select', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'settings_editor', '.settings_editor', on: DEFAULT_EVENTS
widgets 'slider', '.slider', on: DEFAULT_EVENTS

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
