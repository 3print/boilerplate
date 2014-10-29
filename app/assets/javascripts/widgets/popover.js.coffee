widgets.define 'popover', (el) ->
  $el = $(el)
  $el.attr('data-trigger', 'click') if $(window).width() < 992
  $el.popover()
  $el.on 'click', ->
    setTimeout ->
      $('body').on 'click', ->
        $('body').off('click')
        $el.popover('hide')
    , 500
