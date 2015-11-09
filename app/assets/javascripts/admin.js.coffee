#= require jquery
#= require jquery_ujs
#= require jquery.widget
#= require jquery.iframe-transport
#= # require jquery.xdomainrequest.min
#= require jquery.fileupload
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
#= require markdown
#= require locales
#= require i18n
#= require_tree ./widgets

DEFAULT_EVENTS = 'load nested:fieldAdded'

is_mobile = -> $(window).width() < 992

widgets 'navigation_highlight', '.navbar-nav', on: DEFAULT_EVENTS
widgets 'filepicker', '.form-group.file', on: DEFAULT_EVENTS
widgets 'boolean', '.boolean', on: DEFAULT_EVENTS
widgets 'collapse', '.collapse', on: DEFAULT_EVENTS
widgets 'collapse_toggle', '.open-settings', on: DEFAULT_EVENTS
widgets 'datepicker', '.datepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datetimepicker', '.datetimepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datepicker_mobile', '.datepicker', on: DEFAULT_EVENTS, if: is_mobile
widgets 'select2', 'select, .select2', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'markdown', '[data-editor="markdown"]', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'order_table', '.orderable', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'order_list', '.orderable-list', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'blueprint_button', 'button[data-blueprint]', on: DEFAULT_EVENTS
widgets 'blueprint_remove_button', 'button[data-remove]', on: DEFAULT_EVENTS
widgets 'settings_editor', '.settings_editor', on: DEFAULT_EVENTS
widgets 'drag_source', '[data-transferable]', on: DEFAULT_EVENTS
widgets 'drop_target', '[data-drop]', on: DEFAULT_EVENTS
widgets 'auto_resize', 'textarea', on: DEFAULT_EVENTS

widgets 'propagate_input_value', 'input, select', on: DEFAULT_EVENTS

I18n.attachToWindow()


old_insertFields = NestedFormEvents::insertFields
NestedFormEvents::insertFields = (content, assoc, link) ->
  if content.indexOf('<tr') isnt -1
    $tr = $(link).closest('tr')
    $(content).insertBefore($tr)
  else if content.indexOf('<li') isnt -1
    $ul = $(link).parents('.panel').find('.list-group')
    $ul.append(content)
  else
    old_insertFields.call(this, content, assoc, link)

$ ->
  FastClick.attach(document.body)
  $('[data-toggle="collapse"]').on 'click', (e) ->
    e.preventDefault()
    $($(this).attr('data-target')).toggleClass('in')
