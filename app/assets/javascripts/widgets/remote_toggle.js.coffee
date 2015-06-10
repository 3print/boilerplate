widgets.define 'remote_toggle', (el) ->
  $el = $(el)
  method = $el.data('method')
  url_on = $el.data('url-on')
  url_off = $el.data('url-off')
  class_on = $el.data('class-on')
  class_off = $el.data('class-off')
  initial = $el.data('initial')
  handle = window[$el.data('handle')]
  init = window[$el.data('init')]

  [current_url, current_listener] = []

  on_listener = (data) ->
    $el.removeClass(class_off).addClass(class_on)
    current_url = url_off
    current_listener = off_listener
    handle?(data, $el)

  off_listener = (data) ->
    $el.removeClass(class_on).addClass(class_off)
    current_url = url_on
    current_listener = on_listener
    handle?(data, $el)

  on_error = (data) ->
    if data.errors?
      for k,v of data.errors
        $el.before """
        <span class='alert alert-danger alert-dismissible'>
          <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          #{v}
        </span>
        """

  if initial is 'on'
    $el.addClass(class_on)
    current_url = url_off
    current_listener = off_listener
  else
    $el.addClass(class_off)
    current_url = url_on
    current_listener = on_listener

  $el.on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $el.parent().find('.alert').remove()
    $el.addClass 'loading'

    $.ajax {
      method
      url: current_url
      success: current_listener
      dataType: 'json'
      complete: (xhr) ->
        on_error(JSON.parse(xhr.responseText)) if xhr.status >= 400
        $el.removeClass 'loading'
    }

  init?($el)
