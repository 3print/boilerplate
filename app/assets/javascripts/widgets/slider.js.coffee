# A Slider should have the following minimal structure:
#
# .slider
#   .slider-content
#     .slider-loader
#       .icon-wrapper= icon 'circle-o-notch', class: 'fa-spin'
#
#     .slider-next
#     .slider-previous
#     .slider-wrapper
#       .slider-items
#         .slider-item{data: {index: index}}
#
#       .slider-thumbnails
#         %a{data: {index: index}}
#
# The `.slider-loader` div is used as a placeholder during the loading
# of the slider items. It can be omitted.
#
# The `.slider-next` and `slider-previous` reprensents the controls to navigate
# the slider. Again, they can be omitted if needed.
#
# The `.slider-thumbnails` can contains the items' thumbnails. They can contain
# a link with a `data-index` to navigate to a given item on click. It's also
# optional.
#
# The `.slider` div can take several data attributes to customize its behavior:
#
# `data-no-mobile` - If defined, the slider won't initialize on device with a
#                    width < 768px
# `data-auto-run` || `data-autorun` - Whether the slider automatically rotates
#                                     the slides or not.
# `data-margin` - An amount of pixels to use between each slide.
# `data-no-active-item` - Whether to apply an `active` class to the slider
#                         items.
# `data-onchange` - The name of a function on `window` that will be called
#                   when a new slide become active.
# `data-timeout` - The duration of each slide when autorun is enabled.
# `data-force-full-width` - Whether to force the size of the slider items to
#                           take the full available width or not.
# `data-fix-width` - Whether to fix the width of the items after the
#                    initialization of the slider. If true, each item gets a
#                    style attribute correspodning to its current width.
# `data-no-vertical-align` - Whether to center every item vertically or not.
# `data-thumbnail-selector` - The slider can be configured to use thumbnails
#                             lying outside it. In that case the attribute value
#                             is the selector of a parent of the `a[data-index]`
#                             to use a thumbnail controls.

widgets.define 'slider', (el) ->
  slideTimeout = null
  $slider = $(el)
  return if $slider.data('no-mobile') and !window.is_mobile()
  $wrapper = $slider.find('.slider-items')
  itemsMargin = $slider.data('margin') or 0
  autorun = $slider.data('auto-run') ? $slider.data('autorun')
  withLoader = $slider.find('.slider-loader').length > 0
  noActiveItem = $slider.data('no-active-item')
  handler = window[$slider.data('onchange')]
  timeoutDuration = $slider.data('timeout') or 3000
  forceFullWidth = $slider.attr('data-force-full-width')?
  fixWidth = $slider.data('fix-width')
  noVerticalAlign = $slider.data('no-vertical-align')
  autofill = $slider.data('autofill')

  checkForControls = ()->
    if !forceFullWidth && childrenWidth <= $slider.find('.slider-wrapper').width()
      $slider.addClass('no-controls')
      $slider.find('.slider-control').addClass('disabled')
    else
      $slider.removeClass('no-controls')
      $slider.find('.slider-control').removeClass('disabled')

  if $slider.data('thumbnail-selector')
    $thumbs = $("#{$slider.data('thumbnail-selector')} a[data-index]")
  else
    $thumbs = $slider.find(".slider-thumbnails a[data-index]")

  if $slider.find('.slider-item').length <= 1
    $slider.addClass('no-controls')
    $slider.find('.slider-control').addClass('disabled')
  else
    $(window).resize checkForControls
    if $(window).width() <= 1024
      $slider.swipe {
        swipeLeft: (event, direction, distance, duration, fingerCount) -> event.stopImmediatePropagation(); next()
        swipeRight: (event, direction, distance, duration, fingerCount) -> event.stopImmediatePropagation(); prev()
      }

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

  if $slider.find('.slider-item').length > 1
    if forceFullWidth
      $wrapper.children().each ->
        $(this).width($slider.find('.slider-wrapper').width())
    else
      childrenWidth = 0
      $wrapper.children().each ->
        childrenWidth += this.clientWidth

    checkForControls()

  $wrapper.children().each ->
    width = $(this).find('img, .visual').width()
    $(this).find(".content").width width


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
    for n in [0...index]
      $wrapper.append($wrapper.children().first().clone())

    $wrapper.animate marginLeft: "-#{$nextItem[0].offsetLeft + itemsMargin}px", duration: 300, ->
      for n in [0...index]
        $wrapper.children().first().remove()
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
    $wrapper.prepend($lastItem.clone()).css marginLeft: "-#{$lastItem.width() + itemsMargin}px"

    unless noActiveItem
      $prevItem.removeClass('active')
      $lastItem.addClass('active')

      index = $lastItem.data('index')
      $thumbs.removeClass('active')
      $thumbs.filter("[data-index=#{index}]").addClass('active')

    $wrapper.animate marginLeft: '0px', duration: 300, ->
      $lastItem.remove()
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

  $startItem = $slider.find('.slider-item:first-child')

  unless noActiveItem
    $thumbs.first().addClass('active')
    $startItem.addClass('active')

  handler($startItem) if handler?

  if autorun
    if (autorun == "full" && $wrapper.children().length > 0 && $wrapper.children().last().position().left >= $wrapper.width()) || (autorun != "full" && $slider.find('.slider-item').length > 1)
      slideTimeout = setTimeout ->
        next()
      , parseInt(timeoutDuration)
