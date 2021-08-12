widgets.define('order_table', function(el) {
  let $container = $(el);
  let $table = $container.find('table');
  let $table_body = $table.find('tbody');

  let $rows = $container.find('tr');

  let bounds = {
    min: $table_body.offset().top,
    max: $table_body.offset().top + $table_body.height()
  };

  let start = null;
  let drag_offset = null;
  let original_pos = null;
  let original_index = null;
  let last_placeholder_index = null;
  let dragging = false;
  let $parent = null;
  let $dragged = null;
  let $placeholder = null;

  let start_drag = function(e, $el) {
    original_pos = $el.offset();
    last_placeholder_index = (original_index = $el.index());
    dragging = true;
    drag_offset = {x: original_pos.left - e.pageX, y: original_pos.top - e.pageY};

    $parent = $el.parent();
    $placeholder = $(`<tr class='dnd-placeholder'><td colspan='${$el.children().length}'></td></tr>`);
    $placeholder.height($el.height());

    $el.find('td').each(function() { return $(this).width($(this).width()); });

    $el.before($placeholder);
    $el.detach();
    $dragged = $(`<table class='${$table.attr('class')} dragged'/>`);
    $dragged.css({position: 'absolute', width: $table.width()}).append($el);
    return $('body').append($dragged);
  };

  let drag = function(e) {
    $dragged.css({
      left: original_pos.left,
      top: Math.min(bounds.max - $dragged.height(), Math.max(bounds.min, e.pageY + drag_offset.y))
    });

    let $target_row = $(e.target).parents('tr');
    if ($target_row.length === 0) { return; }

    let target_index = $target_row.index();
    if ((target_index !== last_placeholder_index) && $target_row.is(':not(.dnd-placeholder)')) {
      if (target_index < last_placeholder_index) {
        $target_row.before($placeholder);
      } else {
        $target_row.after($placeholder);
      }

      return last_placeholder_index = target_index;
    }
  };

  let stop_drag = function(e, $el, aborted) {
    let target_index;
    if (aborted == null) { aborted = false; }
    let $target_row = $(e.target).parents('tr');
    if ($target_row.length === 0) { aborted = true; }

    if (aborted) {
      target_index = original_index;
    } else {
      target_index = $target_row.index();
    }

    $parent.find('tr').eq(target_index).before($el);

    $placeholder.remove();
    $dragged.remove();

    return update_sequence();
  };

  var update_sequence = () =>
    $rows.each(function() {
      let $row = $(this);
      let $field = $row.find($container.data('order-field'));
      return $field.val($row.index() + 1);
    })
  ;

  return $rows.each(function() {
    let $row = $(this);

    return $row.on('mousedown', function(e) {
      if ($(e.target).is('a')) { return; }
      e.preventDefault();

      start = {x: e.pageX, y: e.pageY};

      $(window).on('mouseup', function(e) {
        if (dragging) {
          stop_drag(e, $row);
          dragging = false;
        }

        return $(window).off('mousemove mouseup');
      });

      return $(window).on('mousemove', function(e) {
        if (!dragging) {
          let difX = e.pageX - start.x;
          let difY = e.pageY - start.y;

          if (Math.abs(Math.sqrt((difX * difX) + (difY * difY))) > 10) {
            return start_drag(e, $row);
          }

        } else {
          return drag(e);
        }
      });
    });
  });
});

    // $row.on 'touchstart', (e) ->
    //   e.preventDefault()
    //   timeout = setTimeout ->
    //     timeout = null
    //     start_drag(e, $row)
    //   , 1000
    //
    //   $row.on 'touchend', (e) ->
    //     if timeout
    //       clearTimeout(timeout)
    //     else
    //       stop_drag(e, $row)
    //
    //   $row.on 'touchmove', (e) ->
    //     if dragging
    //       e.preventDefault()
    //       drag(e)
