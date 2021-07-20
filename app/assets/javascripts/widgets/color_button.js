
widgets.define('color_button', function(el, options, els) {
  let $el = $(el);
  let $els = $(els);

  let $img = $('img.photo');

  if ($img.attr('src') === $el.data('url')) { $el.addClass('selected'); }

  return $el.click(function() {
    $img = $('img.photo');

    if ($img.attr('src') === $el.data('url')) { return false; }

    $els.removeClass('selected');

    let $loading = $('<span class="fa fa-circle-o-notch fa-spin fa-3x" style="position: absolute; top: 50%; left: 50%; margin-top: -21px; margin-left: -21px"></span>');
    $img.after($loading);
    return $img.fadeOut(200, function() {
      let img = new Image;
      img.className = 'photo';
      let $img2 = $(img);
      $img.after($img2);
      $img.remove();
      $img = $img2;
      $el.addClass('selected');
      img.onload = function() {
        $img.fadeIn();
        return $loading.remove();
      };

      return $img.attr('src', $el.data('url'));
    });
  });
});
