widgets.define 'order_list', (el, options={}) ->
  $list = $(el)
  $rows = $list.children('li')

  bounds = null

  grip = $list.data('grip')
  order_callback = options.order_callback or window[$list.data('order-callback')] or ->
    $rows.each ->
      $row = $(this)
      $field = $row.find($list.data('order-field')).first()
      $field.val($row.index() + 1)
  scroll_container = $(options.scroll_container) if options.scroll_container

  blacklist = ['.dnd-placeholder']
  blacklist.push el.getAttribute('data-exclude') if el.hasAttribute('data-exclude')

  start = null
  drag_offset = null
  original_pos = null
  original_index = null
  last_placeholder_index = null
  dragging = false
  $parent = null
  $dragged = null
  $placeholder = null

  start_drag = (e, $el) ->
    if $list.children().filter(-> !$(this).is(blacklist.join(','))).length <= 1
      return

    $list.addClass('dragging')

    bounds = {
      min: $list.offset().top
      max: $list.offset().top + $list.height()
    }
    original_pos = $el.offset()
    last_placeholder_index = original_index = $el.index()
    dragging = true
    drag_offset = {x: original_pos.left - e.pageX, y: original_pos.top - e.pageY}

    $parent = $el.parent()
    $placeholder = $("<li class='dnd-placeholder list-group-item'>&nbsp;</li>")
    $placeholder.height($el.height())

    $el.before($placeholder)
    $el.detach()
    $dragged = $("<ul class='#{$list.attr('class')} dragged' style='z-index: 10'/>")
    $dragged.css(position: 'absolute', width: $list.width()).append($el)
    $('body').append($dragged)

  drag = (e) ->
    offset = if scroll_container? then scroll_container.scrollTop() else 0
    y = Math.min(bounds.max - $dragged.height() - offset, Math.max(bounds.min - offset, e.pageY + drag_offset.y))
    $dragged.css {
      left: original_pos.left
      top: y
    }

    $target_row = $(e.target)
    return if $target_row[0].parentNode isnt $list[0]

    target_index = $target_row.index()
    if target_index isnt last_placeholder_index and !$target_row.is(blacklist.join(', '))
      if target_index < last_placeholder_index
        $target_row.before($placeholder)
      else
        $target_row.after($placeholder)

      last_placeholder_index = target_index

  stop_drag = (e, $el, aborted=false) ->

    if aborted
      target_index = original_index
    else
      target_index = $placeholder.index()


    if target_index >= $list.children().length
      $list.append($el)
    else
      $list.children().eq(target_index).before($el)

    $list.removeClass('dragging')

    $placeholder.remove()
    $dragged.remove()

    update_sequence()
    $el.trigger('sortable:changed')

  update_sequence = ->
    order_callback($list)

  $list.on 'mousedown', grip or '> li', (e) ->
    e.stopImmediatePropagation()
    $row = $(this)

    $row = $row.parents('li') unless $row.is('li')

    return if $(e.target).is('a') or $(e.target).is('input')
    e.preventDefault()

    start = {x: e.pageX, y: e.pageY}

    $(window).on 'mouseup', (e) ->
      e.stopImmediatePropagation()
      if dragging
        stop_drag(e, $row)
        dragging = false

      $(window).off 'mousemove mouseup'

    $(window).on 'mousemove', (e) ->
      e.stopImmediatePropagation()
      unless dragging
        difX = e.pageX - start.x
        difY = e.pageY - start.y

        if Math.abs(Math.sqrt(difX * difX + difY * difY)) > 10
          start_drag(e, $row)

      else
        drag(e)
