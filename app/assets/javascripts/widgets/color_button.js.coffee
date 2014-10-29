
widgets.define 'color_button', (el, options, els) ->
  $el = $(el)
  $els = $(els)

  $img = $('img.photo')

  $el.addClass('selected') if $img.attr('src') is $el.data('url')

  $el.click ->
    $img = $('img.photo')

    return false if $img.attr('src') is $el.data('url')

    $els.removeClass('selected')

    $loading = $('<span class="fa fa-circle-o-notch fa-spin fa-3x" style="position: absolute; top: 50%; left: 50%; margin-top: -21px; margin-left: -21px"></span>')
    $img.after $loading
    $img.fadeOut 200, ->
      img = new Image
      img.className = 'photo'
      $img2 = $(img)
      $img.after($img2)
      $img.remove()
      $img = $img2
      $el.addClass('selected')
      img.onload = ->
        $img.fadeIn()
        $loading.remove()

      $img.attr('src', $el.data('url'))
