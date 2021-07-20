// A Slider should have the following minimal structure:
//
// .slider
//   .slider-content
//     .slider-loader
//       .icon-wrapper= icon 'circle-o-notch', class: 'fa-spin'
//
//     .slider-next
//     .slider-previous
//     .slider-wrapper
//       .slider-items
//         .slider-item{data: {index: index}}
//
//       .slider-thumbnails
//         %a{data: {index: index}}
//
// The `.slider-loader` div is used as a placeholder during the loading
// of the slider items. It can be omitted.
//
// The `.slider-next` and `slider-previous` reprensents the controls to navigate
// the slider. Again, they can be omitted if needed.
//
// The `.slider-thumbnails` can contains the items' thumbnails. They can contain
// a link with a `data-index` to navigate to a given item on click. It's also
// optional.
//
// The `.slider` div can take several data attributes to customize its behavior:
//
// `data-no-mobile` - If defined, the slider won't initialize on device with a
//                    width < 768px
// `data-auto-run` || `data-autorun` - Whether the slider automatically rotates
//                                     the slides or not.
// `data-margin` - An amount of pixels to use between each slide.
// `data-no-active-item` - Whether to apply an `active` class to the slider
//                         items.
// `data-onchange` - The name of a function on `window` that will be called
//                   when a new slide become active.
// `data-timeout` - The duration of each slide when autorun is enabled.
// `data-force-full-width` - Whether to force the size of the slider items to
//                           take the full available width or not.
// `data-fix-width` - Whether to fix the width of the items after the
//                    initialization of the slider. If true, each item gets a
//                    style attribute correspodning to its current width.
// `data-no-vertical-align` - Whether to center every item vertically or not.
// `data-thumbnail-selector` - The slider can be configured to use thumbnails
//                             lying outside it. In that case the attribute value
//                             is the selector of a parent of the `a[data-index]`
//                             to use a thumbnail controls.

widgets.define('slider', function(el) {
  let $thumbs, left;
  let slideTimeout = null;
  let $slider = $(el);
  if ($slider.data('no-mobile') && !window.isMobile()) { return; }
  let $wrapper = $slider.find('.slider-items');
  let itemsMargin = $slider.data('margin') || 0;
  let autorun = (left = $slider.data('auto-run')) != null ? left : $slider.data('autorun');
  let withLoader = $slider.find('.slider-loader').length > 0;
  let noActiveItem = $slider.data('no-active-item');
  let handler = window[$slider.data('onchange')];
  let timeoutDuration = $slider.data('timeout') || 3000;
  let forceFullWidth = ($slider.attr('data-force-full-width') != null);
  let fixWidth = $slider.data('fix-width');
  let noVerticalAlign = $slider.data('no-vertical-align');
  let autofill = $slider.data('autofill');

  let checkForControls = function(){
    if (!forceFullWidth && (childrenWidth <= $slider.find('.slider-wrapper').width())) {
      $slider.addClass('no-controls');
      return $slider.find('.slider-control').addClass('disabled');
    } else {
      $slider.removeClass('no-controls');
      return $slider.find('.slider-control').removeClass('disabled');
    }
  };

  if ($slider.data('thumbnail-selector')) {
    $thumbs = $(`${$slider.data('thumbnail-selector')} a[data-index]`);
  } else {
    $thumbs = $slider.find(".slider-thumbnails a[data-index]");
  }

  if ($slider.find('.slider-item').length <= 1) {
    $slider.addClass('no-controls');
    $slider.find('.slider-control').addClass('disabled');
  } else {
    $(window).resize(checkForControls);
    if ($(window).width() <= 1024) {
      $slider.swipe({
        swipeLeft(event, direction, distance, duration, fingerCount) { event.stopImmediatePropagation(); return next(); },
        swipeRight(event, direction, distance, duration, fingerCount) { event.stopImmediatePropagation(); return prev(); }
      });
    }
  }

  $slider.find('.slider-item:not(:visible)').remove();

  if (!noVerticalAlign) {
    $wrapper.children().each(function() {
      let $el = $(this);
      let $img = $el.find('img');

      $el.width($el.width());
      let dif = ($el.height() - $img.height()) / 2;
      return $img.css({marginTop: `${dif}px`});
    });
  }

  if (fixWidth) {
    $wrapper.children().each(function() {
      return $(this).width($(this).width());
    });
  }

  if ($slider.find('.slider-item').length > 1) {
    if (forceFullWidth) {
      $wrapper.children().each(function() {
        return $(this).width($slider.find('.slider-wrapper').width());
      });
    } else {
      var childrenWidth = 0;
      $wrapper.children().each(function() {
        return childrenWidth += this.clientWidth;
      });
    }

    checkForControls();
  }

  $wrapper.children().each(function() {
    let width = $(this).find('img, .visual').width();
    return $(this).find(".content").width(width);
  });


  if (withLoader) {
    $slider.find('.slider-loader').fadeOut();
  }

  let $next = $slider.find('.slider-next');
  let $prev = $slider.find('.slider-previous');

  let goto = function($nextItem, cb) {
    let asc, end, i;
    let n;
    clearTimeout(slideTimeout);
    let index = $nextItem.index();
    let $firstItem = $slider.find('.slider-item:first-child');

    if (!noActiveItem) {
      $firstItem.removeClass('active');
      $nextItem.addClass('active');

      $thumbs.removeClass('active');
      $thumbs.filter(`[data-index=${$nextItem.data('index')}]`).addClass('active');
    }

    if (handler != null) { handler($nextItem, $firstItem); }
    for (i = 0, n = i, end = index, asc = 0 <= end; asc ? i < end : i > end; asc ? i++ : i--, n = i) {
      $wrapper.append($wrapper.children().first().clone());
    }

    return $wrapper.animate({marginLeft: `-${$nextItem[0].offsetLeft + itemsMargin}px`, duration: 300}, function() {
      let asc1, end1;
      for (n = 0, end1 = index, asc1 = 0 <= end1; asc1 ? n < end1 : n > end1; asc1 ? n++ : n--) {
        $wrapper.children().first().remove();
      }
      $wrapper.css({marginLeft: 0});
      return (typeof cb === 'function' ? cb() : undefined);
    });
  };

  var next = function(cb) {
    goto($slider.find('.slider-item:nth-child(2)'), cb);

    if (autorun) { return slideTimeout = setTimeout(next, timeoutDuration); }
  };

  var prev = function(cb) {
    clearTimeout(slideTimeout);
    let $lastItem = $slider.find('.slider-item:last-child');
    let $prevItem = $slider.find('.slider-item:nth-child(1)');

    if (handler != null) { handler($lastItem, $prevItem); }
    $wrapper.prepend($lastItem.clone()).css({marginLeft: `-${$lastItem.width() + itemsMargin}px`});

    if (!noActiveItem) {
      $prevItem.removeClass('active');
      $lastItem.addClass('active');

      let index = $lastItem.data('index');
      $thumbs.removeClass('active');
      $thumbs.filter(`[data-index=${index}]`).addClass('active');
    }

    $wrapper.animate({marginLeft: '0px', duration: 300}, function() {
      $lastItem.remove();
      return (typeof cb === 'function' ? cb() : undefined);
    });

    if (autorun) { return slideTimeout = setTimeout(next, timeoutDuration); }
  };

  $thumbs.on('click', function() {
    let $this = $(this);
    let index = $this.data('index');
    return goto($slider.find(`.slider-item[data-index=${index}]`));
  });

  $next.on('click', function() {
    $next.css('pointer-events', 'none');
    return next(() => $next.css('pointer-events', 'all'));
  });

  $prev.on('click', function() {
    $prev.css('pointer-events', 'none');
    return prev(() => $prev.css('pointer-events', 'all'));
  });

  let $startItem = $slider.find('.slider-item:first-child');

  if (!noActiveItem) {
    $thumbs.first().addClass('active');
    $startItem.addClass('active');
  }

  if (handler != null) { handler($startItem); }

  if (autorun) {
    if (((autorun === "full") && ($wrapper.children().length > 0) && ($wrapper.children().last().position().left >= $wrapper.width())) || ((autorun !== "full") && ($slider.find('.slider-item').length > 1))) {
      return slideTimeout = setTimeout(() => next()
      , parseInt(timeoutDuration));
    }
  }
});
