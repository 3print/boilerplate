
widgets.define 'drag_source', (el) ->
  $el = $(el)

  keep_source = $el.data('keep')
  flavor = $el.data('flavor') ? 'all'
  transferable = $el.data('transferable').toString()
  grip_selector = $el.data('grip')
  $grip = if grip_selector? then $el.find(grip_selector) else $el

  start = null
  drag_offset = null
  dragging = false
  original_pos = null
  original_parent = null
  original_index = null
  $potential_targets = null
  last_placeholder_index = null
  $target = null
  $dragged = null
  $placeholder = null

  start_drag = (e) ->
    targetSelector = if flavor is 'all' then '[data-drop]' else "[data-drop][data-flavor='#{flavor}']"

    original_pos = $el.offset()
    original_parent = $el.parent()
    original_index = $el.index()

    dragging = true
    drag_offset = {x: original_pos.left - e.pageX, y: original_pos.top - e.pageY}

    $dragged = if keep_source then $el.clone() else $el

    $dragged.css(position: 'absolute', width: $el.width()).addClass('dragged')
    $('body').append($dragged)

    $placeholder = $("<li class='dnd-placeholder'></li>")
    $potential_targets = $(targetSelector)
    $potential_targets.on 'mouseover', ->
      $target = $(this)
      $target.addClass('drop')
      $target.append($placeholder)

      $target.on 'mousemove', (e) ->
        {pageY} = e

        $target.children(':not(.dnd-placeholder)').each (i, el) ->
          {top, height} = el.getBoundingClientRect()

          if i is 0 and pageY < top + height / 2
            $(el).before($placeholder)
          else if pageY > top + height / 2
            $(el).after($placeholder)

      $target.on 'mouseout', ->
        $placeholder.detach()
        if $target?
          $target.removeClass('drop')
          $target.off 'mousemove mouseout'
          last_placeholder_index = null
          $target = null

  stop_drag = (e) ->
    if $target?
      target_index = $placeholder.index()
      target_parent = $placeholder.parent()

      target_slot = target_parent.parents('.slot').attr('data-slot')
      $dragged.removeClass('dragged').attr('style', '')

      if transferable.indexOf('block:') is 0
        block_id = parseInt(transferable.slice(6))
        original_slot = $dragged.attr('data-slot')

        layout_editor.moveBlockFromSlotById(original_slot, block_id, target_slot, target_index)
      else
        block = layout_editor.getBlockById(transferable)
        layout_editor.addBlockToSlotAt(target_slot, block, target_index)
        $dragged.remove()

      $placeholder.detach()
      $target.removeClass('drop')

    else
      $placeholder.detach()
      if keep_source
        $dragged.remove()
      else if original_parent.length > 0
        $next = original_parent.children().eq(original_index)
        if $next.length > 0
          $next.before($el)
        else
          original_parent.append($el)
        $el.removeClass('dragged').attr('style','')

  drag = (e) ->
    x = e.pageX + drag_offset.x
    y = e.pageY + drag_offset.y

    $dragged.css {
      left: x
      top: y
    }

  $grip.on 'mousedown', (e) ->
    e.stopImmediatePropagation()
    e.preventDefault()

    start = {x: e.pageX, y: e.pageY}

    $(window).on 'mouseup', (e) ->
      e.stopImmediatePropagation()
      if dragging
        stop_drag(e)
        dragging = false

      $(window).off 'mousemove mouseup'
      $potential_targets?.off 'mouseover mouseout mousemove'

    $(window).on 'mousemove', (e) ->
      e.stopImmediatePropagation()
      unless dragging
        difX = e.pageX - start.x
        difY = e.pageY - start.y

        if Math.abs(Math.sqrt(difX * difX + difY * difY)) > 10
          start_drag(e)
          drag(e)

      else
        drag(e)


widgets.define 'drop_target', (el) ->
