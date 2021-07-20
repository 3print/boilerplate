widgets.define('order_list', function(el, options) {
  let left, scroll_container;
  if (options == null) { options = {}; }
  let $list = $(el);
  let $rows = $list.children('li');

  let lock_x = (left = $list.data('lock-x')) != null ? left : true;

  let bounds = null;
  let blacklist = ['.dnd-placeholder'];
  if (el.hasAttribute('data-exclude')) { blacklist.push(el.getAttribute('data-exclude')); }

  let grip = $list.data('grip');
  let order_callback = options.order_callback || window[$list.data('order-callback')] || (() =>
    $list.children('li').filter(function() { return !$(this).is(blacklist.join(',')); }).each(function() {
      let $row = $(this);
      let $field = $row.find($list.data('order-field')).first();
      return $field.val($row.index() + 1);
    })
  );
  if (options.scroll_container) { scroll_container = $(options.scroll_container); }


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
    if ($list.children().filter(function() { return !$(this).is(blacklist.join(',')); }).length <= 1) {
      return;
    }

    $list.addClass('dragging');

    bounds = {
      minX: $list.offset().left,
      maxX: $list.offset().left + $list.width(),
      minY: $list.offset().top,
      maxY: $list.offset().top + $list.height()
    };

    original_pos = $el.offset();
    last_placeholder_index = (original_index = $el.index());
    dragging = true;
    drag_offset = {
      x: original_pos.left - e.pageX,
      y: original_pos.top - e.pageY
    };

    $parent = $el.parent();
    $placeholder = $("<li class='dnd-placeholder list-group-item'>&nbsp;</li>");
    $placeholder.height($el.height());

    $el.before($placeholder);
    $el.detach();
    $dragged = $(`<ul class='${$list.attr('class')} dragged' style='z-index: 10'/>`);
    $dragged.css({position: 'absolute', width: $list.width()}).append($el);
    return $('body').append($dragged);
  };

  let drag = function(e) {
    let offsetY = (scroll_container != null) ? scroll_container.scrollTop() : 0;
    let offsetX = (scroll_container != null) ? scroll_container.scrollLeft() : 0;

    let y = Math.min(bounds.maxY - $dragged.height() - offsetY, Math.max(bounds.minY - offsetY, e.pageY + drag_offset.y));
    let x = Math.min(bounds.maxX - $dragged.width() - offsetX, Math.max(bounds.minX - offsetX, e.pageX + drag_offset.x));

    $dragged.css({
      left: lock_x ? original_pos.left : x,
      top: y
    });

    let $target_row = $(e.target);
    if ($target_row[0].parentNode !== $list[0]) { return; }

    let target_index = $target_row.index();
    if ((target_index !== last_placeholder_index) && !$target_row.is(blacklist.join(', '))) {
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
    if (aborted) {
      target_index = original_index;
    } else {
      target_index = $placeholder.index();
    }


    if (target_index >= $list.children().length) {
      $list.append($el);
    } else {
      $list.children().eq(target_index).before($el);
    }

    $list.removeClass('dragging');

    $placeholder.remove();
    $dragged.remove();

    update_sequence();
    return $el.trigger('sortable:changed');
  };

  var update_sequence = () => order_callback($list);

  return $list.on('mousedown', grip || '> li', function(e) {
    e.stopImmediatePropagation();
    let $row = $(this);

    if (!$row.is('li')) { $row = $row.parents('li'); }

    let $t = $(e.target);

    if ($t.is('a') || $t.is('input') || $t.is('.locked')) { return; }
    e.preventDefault();

    start = {x: e.pageX, y: e.pageY};

    $(window).on('mouseup', function(e) {
      e.stopImmediatePropagation();
      if (dragging) {
        stop_drag(e, $row);
        dragging = false;
      }

      return $(window).off('mousemove mouseup');
    });

    return $(window).on('mousemove', function(e) {
      e.stopImmediatePropagation();
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
