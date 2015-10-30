widgets.define 'auto_resize', (el) ->
  resize = (txt) ->
    return unless txt
    $txt = $(txt)
    $txt.height(0)
    $txt.height(txt.scrollHeight)

  $this = $(el)
  $this.on 'input', ->
    resize(el)
    true

  setTimeout ->
    resize(el)
  , 500
