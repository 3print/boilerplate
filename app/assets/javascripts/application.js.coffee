#= require jquery
#= require jquery_ujs
#= require fastclick
#= require touch-swipe
#= require bootstrap
#= require datepicker
#= require datetimepicker
#= require select2
#= require_tree ./widgets

DEFAULT_EVENTS = 'load'

is_mobile = -> $(window).width() < 992

widgets 'popover', '[data-toggle=popover]', on: DEFAULT_EVENTS
widgets 'slider', '.slider', on: DEFAULT_EVENTS
widgets 'boolean', '.boolean', on: DEFAULT_EVENTS
widgets 'auto_resize', 'textarea', on: DEFAULT_EVENTS
widgets 'select2', 'select', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datepicker', '.datepicker', on: DEFAULT_EVENTS, unless: is_mobile
widgets 'datepicker_mobile', '.datepicker', on: DEFAULT_EVENTS, if: is_mobile
widgets 'select_url', '[data-toggle=url]', on: DEFAULT_EVENTS
widgets 'color_button', '.color-icon-wrapper[data-url]', on: DEFAULT_EVENTS

$ ->
  FastClick.attach(document.body)

window.home_item_changed = (item, previous_item) ->
  if previous_item?
    $('.content-header').removeClass 'item_' + previous_item.data('index')
    previous_item.find('.col-sm-7').fadeOut(100)

  item.find('.col-sm-7').fadeIn(100) if item?
  $('.content-header').addClass 'item_' + item.data('index')
