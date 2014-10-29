widgets.define 'order_table', (el) ->
  $container = $(el)
  $table = $container.find('table')
  $table_body = $table.find('tbody')

  $rows = $container.find('tr')

  bounds = {
    min: $table_body.offset().top
    max: $table_body.offset().top + $table_body.height()
  }

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
    original_pos = $el.offset()
    last_placeholder_index = original_index = $el.index()
    dragging = true
    drag_offset = {x: original_pos.left - e.pageX, y: original_pos.top - e.pageY}

    $parent = $el.parent()
    $placeholder = $("<tr class='dnd-placeholder'><td colspan='#{$el.children().length}'></td></tr>")
    $placeholder.height($el.height())

    $el.find('td').each -> $(this).width($(this).width())

    $el.before($placeholder)
    $el.detach()
    $dragged = $("<table class='#{$table.attr('class')} dragged'/>")
    $dragged.css(position: 'absolute', width: $table.width()).append($el)
    $('body').append($dragged)

  drag = (e) ->
    $dragged.css {
      left: original_pos.left
      top: Math.min(bounds.max - $dragged.height(), Math.max(bounds.min, e.pageY + drag_offset.y))
    }

    $target_row = $(e.target).parents('tr')
    return if $target_row.length is 0

    target_index = $target_row.index()
    if target_index isnt last_placeholder_index and $target_row.is(':not(.dnd-placeholder)')
      if target_index < last_placeholder_index
        $target_row.before($placeholder)
      else
        $target_row.after($placeholder)

      last_placeholder_index = target_index

  stop_drag = (e, $el, aborted=false) ->
    $target_row = $(e.target).parents('tr')
    aborted = true if $target_row.length is 0

    if aborted
      target_index = original_index
    else
      target_index = $target_row.index()

    $parent.find('tr').eq(target_index).before($el)

    $placeholder.remove()
    $dragged.remove()

    update_sequence()

  update_sequence = ->
    $rows.each ->
      $row = $(this)
      $field = $row.find($container.data('order-field'))
      $field.val($row.index() + 1)

  $rows.each ->
    $row = $(this)

    $row.on 'mousedown', (e) ->
      return if $(e.target).is('a')
      e.preventDefault()

      start = {x: e.pageX, y: e.pageY}

      $(window).on 'mouseup', (e) ->
        if dragging
          stop_drag(e, $row)
          dragging = false

        $(window).off 'mousemove mouseup'

      $(window).on 'mousemove', (e) ->
        unless dragging
          difX = e.pageX - start.x
          difY = e.pageY - start.y

          if Math.abs(Math.sqrt(difX * difX + difY * difY)) > 10
            start_drag(e, $row)

        else
          drag(e)

    # $row.on 'touchstart', (e) ->
    #   e.preventDefault()
    #   timeout = setTimeout ->
    #     timeout = null
    #     start_drag(e, $row)
    #   , 1000
    #
    #   $row.on 'touchend', (e) ->
    #     if timeout
    #       clearTimeout(timeout)
    #     else
    #       stop_drag(e, $row)
    #
    #   $row.on 'touchmove', (e) ->
    #     if dragging
    #       e.preventDefault()
    #       drag(e)
