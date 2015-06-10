widgets.define 'remote_link', (el) ->
  $el = $(el)
  method = $el.data('method')
  url = $el.attr('href')
  handle = window[$el.data('handle')]

  listener = (data) -> handle?(data, $el)

  on_error = (data) ->
    if data.errors?
      for k,v of data.errors
        $el.before """
        <span class='alert alert-danger alert-dismissible'>
          <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          #{v}
        </span>
        """

  $el.on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $el.parent().find('.alert').remove()
    $el.addClass 'loading'

    $.ajax {
      method
      url: url
      success: listener
      dataType: 'json'
      complete: (xhr) ->
        on_error(JSON.parse(xhr.responseText)) if xhr.status >= 400
        $el.removeClass 'loading'
    }
