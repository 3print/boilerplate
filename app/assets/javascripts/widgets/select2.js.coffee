widgets.define 'select2', (el) ->
  $el = $(el)
  $el.select2 width: 'element'
  label = $el.prev().find('.select2-chosen')
  label.text($el.attr('placeholder')) if label.text() is 'undefined'
  label.parents('.select2-container').addClass('form-control')
  $el.removeClass('form-control')
