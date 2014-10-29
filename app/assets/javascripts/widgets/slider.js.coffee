
widgets.define 'slider', (el) ->
  $slider = $(el)
  return if $slider.data('no-mobile') and $(window).width() < 768
  $wrapper = $slider.find('.slider-items')
  items_margin = $slider.data('margin') or 0
  autorun = $slider.data('auto-run')
  with_loader = $slider.data('has-loader')
  handler = window[$slider.data('onchange')]

  $slider.find('.slider-item:not(:visible)').remove()

  unless $slider.data('no-vertical-align')
    $wrapper.children().each ->
      $el = $(this)
      $img = $el.find('img')

      $el.width($el.width())
      dif = ($el.height() - $img.height()) / 2
      $img.css marginTop: "#{dif}px"

  if $slider.data('fix-width')
    $wrapper.children().each ->
      $(this).width($(this).width())

  if $slider.data('force-full-width')
    $wrapper.children().each ->
      $(this).width($slider.width())

  if with_loader
    $slider.find('.slider-loader').fadeOut()

  $next = $slider.find('.slider-next')
  $prev = $slider.find('.slider-previous')

  next = (cb) ->
    $first_item = $slider.find('.slider-item:first-child')
    handler($slider.find('.slider-item:nth-child(2)'), $first_item) if handler?
    $wrapper.animate marginLeft: "-#{$first_item.width() + items_margin}px", duration: 300, ->
      $wrapper.append($first_item).css(marginLeft: 0)
      cb?()

  prev = (cb) ->
    $last_item = $slider.find('.slider-item:last-child')
    handler($last_item, $slider.find('.slider-item:nth-child(1)')) if handler?
    $wrapper.prepend($last_item).css marginLeft: "-#{$last_item.width() + items_margin}px"
    $wrapper.animate marginLeft: '0px', duration: 300, cb

  $next.on 'click', ->
    $next.css 'pointer-events', 'none'
    next ->
      $next.css 'pointer-events', 'all'

  $prev.on 'click', ->
    $prev.css 'pointer-events', 'none'
    prev ->
      $prev.css 'pointer-events', 'all'

  if $(window).width() < 992
    $slider.swipe {
      swipeLeft: (event, direction, distance, duration, fingerCount) -> next()
      swipeRight: (event, direction, distance, duration, fingerCount) -> prev()
    }

  handler($slider.find('.slider-item:first-child')) if handler?

  if autorun and $slider.find('.slider-item:visible').length > 1
    setInterval ->
      next()
    , parseInt($slider.data('timeout') or 3000)
