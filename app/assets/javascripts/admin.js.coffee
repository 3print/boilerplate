#= require jquery
#= require jquery_ujs
#= require jquery.widget
#= require jquery.iframe-transport
#= # require jquery.xdomainrequest.min
#= require jquery.fileupload
#= require bootstrap
#= require datepicker
#= require fastclick
#= require widgets
#= require select2
#= require nested_form
#= require_tree ./widgets

DEFAULT_EVENTS = 'load nested:fieldAdded'

is_mobile = -> $(window).width() < 992

widgets 'navigation_highlight', 'body', on: DEFAULT_EVENTS
widgets 'auto_resize', 'textarea', on: DEFAULT_EVENTS
widgets 'filepicker', '.form-group.file', on: DEFAULT_EVENTS
widgets 'boolean', '.boolean', on: DEFAULT_EVENTS
widgets 'collapse', '.collapse', on: DEFAULT_EVENTS
widgets 'datepicker', '.datepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datepicker_mobile', '.datepicker', on: DEFAULT_EVENTS, if: is_mobile
widgets 'select2', 'select', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'order_table', '.orderable', on: DEFAULT_EVENTS, unless: is_mobile

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
