
widgets.define 'slider', (el) ->
  slideTimeout = null
  $slider = $(el)
  return if $slider.data('no-mobile') and $(window).width() < 768
  $wrapper = $slider.find('.slider-items')
  itemsMargin = $slider.data('margin') or 0
  autorun = $slider.data('auto-run') ? $slider.data('autorun')
  withLoader = $slider.data('has-loader')
  noActiveItem = $slider.data('no-active-item')
  handler = window[$slider.data('onchange')]
  timeoutDuration = $slider.data('timeout') or 3000
  forceFullWidth = $slider.data('force-full-width')
  fixWidth = $slider.data('fix-width')
  noVerticalAlign = $slider.data('no-vertical-align')

  if $slider.data('thumbnail-selector')
    $thumbs = $("#{$slider.data('thumbnail-selector')} a[data-index]")
  else
    $thumbs = $slider.find(".slider-thumbnails a[data-index]")

  if $slider.find('.slider-item').length <= 1
    $slider.addClass('no-controls')

  $slider.find('.slider-item:not(:visible)').remove()

  unless noVerticalAlign
    $wrapper.children().each ->
      $el = $(this)
      $img = $el.find('img')

      $el.width($el.width())
      dif = ($el.height() - $img.height()) / 2
      $img.css marginTop: "#{dif}px"

  if fixWidth
    $wrapper.children().each ->
      $(this).width($(this).width())

  if forceFullWidth
    $wrapper.children().each ->
      $(this).width($slider.find('.slider-wrapper').width())
  else
    childrenWidth = 0
    $wrapper.children().each -> childrenWidth += $(this).width()

    if childrenWidth < $slider.find('.slider-wrapper').width()
      $slider.addClass('no-controls')

  if withLoader
    $slider.find('.slider-loader').fadeOut()

  $next = $slider.find('.slider-next')
  $prev = $slider.find('.slider-previous')

  goto = ($nextItem, cb) ->
    clearTimeout(slideTimeout)
    index = $nextItem.index()
    $firstItem = $slider.find('.slider-item:first-child')

    unless noActiveItem
      $firstItem.removeClass('active')
      $nextItem.addClass('active')

      $thumbs.removeClass('active')
      $thumbs.filter("[data-index=#{$nextItem.data('index')}]").addClass('active')

    handler($nextItem, $firstItem) if handler?
    $wrapper.animate marginLeft: "-#{$nextItem[0].offsetLeft + itemsMargin}px", duration: 300, ->
      for n in [0...index]
        $wrapper.append($wrapper.children().first())

      $wrapper.css(marginLeft: 0)
      cb?()

  next = (cb) ->
    goto($slider.find('.slider-item:nth-child(2)'), cb)

    slideTimeout = setTimeout(next, timeoutDuration) if autorun

  prev = (cb) ->
    clearTimeout(slideTimeout)
    $lastItem = $slider.find('.slider-item:last-child')
    $prevItem = $slider.find('.slider-item:nth-child(1)')

    handler($lastItem, $prevItem) if handler?
    $wrapper.prepend($lastItem).css marginLeft: "-#{$lastItem.width() + itemsMargin}px"

    unless noActiveItem
      $prevItem.removeClass('active')
      $lastItem.addClass('active')

      index = $lastItem.data('index')
      $thumbs.removeClass('active')
      $thumbs.filter("[data-index=#{index}]").addClass('active')

    $wrapper.animate marginLeft: '0px', duration: 300, ->
      cb?()

    slideTimeout = setTimeout(next, timeoutDuration) if autorun

  $thumbs.on 'click', ->
    $this = $(this)
    index = $this.data('index')
    goto $slider.find(".slider-item[data-index=#{index}]")

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

  $startItem = $slider.find('.slider-item:first-child')

  unless noActiveItem
    $thumbs.first().addClass('active')
    $startItem.addClass('active')

  handler($startItem) if handler?

  if autorun and $slider.find('.slider-item').length > 1
    slideTimeout = setTimeout ->
      next()
    , parseInt(timeoutDuration)
