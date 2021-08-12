
widgets.define('drag_source', function(el) {
  let left;
  let $el = $(el);

  let keep_source = $el.data('keep');
  let flavor = (left = $el.data('flavor')) != null ? left : 'all';
  let transferable = $el.data('transferable').toString();
  let grip_selector = $el.data('grip');
  let $grip = (grip_selector != null) ? $el.find(grip_selector) : $el;

  let start = null;
  let drag_offset = null;
  let dragging = false;
  let original_pos = null;
  let original_parent = null;
  let original_index = null;
  let $potential_targets = null;
  let last_placeholder_index = null;
  let $target = null;
  let $dragged = null;
  let $placeholder = null;

  let start_drag = function(e) {
    let targetSelector = flavor === 'all' ? '[data-drop]' : `[data-drop][data-flavor='${flavor}']`;

    original_pos = $el.offset();
    original_parent = $el.parent();
    original_index = $el.index();

    dragging = true;
    drag_offset = {x: original_pos.left - e.pageX, y: original_pos.top - e.pageY};

    $dragged = keep_source ? $el.clone() : $el;

    $dragged.css({position: 'absolute', width: $el.width()}).addClass('dragged');
    $('body').append($dragged);

    $placeholder = $("<li class='dnd-placeholder'></li>");
    $potential_targets = $(targetSelector);
    return $potential_targets.on('mouseover', function() {
      $target = $(this);
      $target.addClass('drop');
      $target.append($placeholder);

      $target.on('mousemove', function(e) {
        let {pageY} = e;

        return $target.children(':not(.dnd-placeholder)').each(function(i, el) {
          let {top, height} = el.getBoundingClientRect();

          if ((i === 0) && (pageY < (top + (height / 2)))) {
            return $(el).before($placeholder);
          } else if (pageY > (top + (height / 2))) {
            return $(el).after($placeholder);
          }
        });
      });

      return $target.on('mouseout', function() {
        $placeholder.detach();
        if ($target != null) {
          $target.removeClass('drop');
          $target.off('mousemove mouseout');
          last_placeholder_index = null;
          return $target = null;
        }
      });
    });
  };

  let stop_drag = function(e) {
    if ($target != null) {
      let target_index = $placeholder.index();
      let target_parent = $placeholder.parent();

      let target_slot = target_parent.parents('.slot').attr('data-slot');
      $dragged.removeClass('dragged').attr('style', '');

      if (transferable.indexOf('block:') === 0) {
        let block_id = parseInt(transferable.slice(6));
        let original_slot = $dragged.attr('data-slot');

        layout_editor.moveBlockFromSlotById(original_slot, block_id, target_slot, target_index);
      } else {
        let block = layout_editor.getBlockById(transferable);
        layout_editor.addBlockToSlotAt(target_slot, block, target_index);
        $dragged.remove();
      }

      $placeholder.detach();
      return $target.removeClass('drop');

    } else {
      $placeholder.detach();
      if (keep_source) {
        return $dragged.remove();
      } else if (original_parent.length > 0) {
        let $next = original_parent.children().eq(original_index);
        if ($next.length > 0) {
          $next.before($el);
        } else {
          original_parent.append($el);
        }
        return $el.removeClass('dragged').attr('style','');
      }
    }
  };

  let drag = function(e) {
    let x = e.pageX + drag_offset.x;
    let y = e.pageY + drag_offset.y;

    return $dragged.css({
      left: x,
      top: y
    });
  };

  return $grip.on('mousedown', function(e) {
    e.stopImmediatePropagation();
    e.preventDefault();

    start = {x: e.pageX, y: e.pageY};

    $(window).on('mouseup', function(e) {
      e.stopImmediatePropagation();
      if (dragging) {
        stop_drag(e);
        dragging = false;
      }

      $(window).off('mousemove mouseup');
      return ($potential_targets != null ? $potential_targets.off('mouseover mouseout mousemove') : undefined);
    });

    return $(window).on('mousemove', function(e) {
      e.stopImmediatePropagation();
      if (!dragging) {
        let difX = e.pageX - start.x;
        let difY = e.pageY - start.y;

        if (Math.abs(Math.sqrt((difX * difX) + (difY * difY))) > 10) {
          start_drag(e);
          return drag(e);
        }

      } else {
        return drag(e);
      }
    });
  });
});


widgets.define('drop_target', function(el) {});
