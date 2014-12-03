$file_fields = []
i = 0
widgets.define 'file_upload', (el) ->
  $.support.cors = true
  $block = $(el)

  preview   = $block.find('.preview').first()
  progress  = $block.find('.progress-container').first()
  hidden    = $block.find('input.url').first()
  input     = $block.find('input[type="file"]').first()
  uploader  = $('.direct-upload').first().clone()
  $file_field = uploader.find('input[type="file"]')
  $file_field.attr('id', "my-uploader-#{i}")
  $keeper = $block.find('.keep')

  $label = $block.find('label')
  $label.attr('for', "my-uploader-#{i}").addClass('btn btn-primary btn-block')

  input.hide()

  $keeper.click -> hidden.val(preview.find('img').attr('src'))

  return unless preview.length && input.length && uploader.length

  return if $(input[0]).attr('id') in $file_fields
  $file_fields.push $(input[0]).attr('id')

  uploader.insertAfter($('.direct-upload').first())

  progress.addClass('target-area')
  progress.append('<div class="progress progress-striped progress-sm"><div class="progress-bar progress-bar-info"></div></div>')
  # $label.bind 'click', -> uploader.find('input[type="file"]').click()
  prevUpload = null

  redirect_url = document.location.protocol + '//' + document.location.host + '/result.html'

  is_ie = $('html').hasClass('ie9') or $('html').hasClass('lt-ie9')

  $(uploader).fileupload
    url:          uploader.attr('action')
    type:         'POST'
    autoUpload:   true
    sequentialUploads: true
    crossDomain: true
    redirect: redirect_url if is_ie
    redirectParamName: 'success_action_redirect' if is_ie
    forceIframeTransport: is_ie

    # This is really important as s3 gives us back the url of the file in a XML document
    # dataType:     'xml',
    dataType:     'text',

    add: (event, data) ->
      signed_data =
        doc:
          title: data.files[0].name

      signed_data['success_action_redirect'] = redirect_url if is_ie

      $.ajax
        url:      '/admin/signed_urls'
        type:     'GET'
        dataType: 'json'
        async:    false

        # send the file name to the server so it can generate the key param
        data: signed_data

        success:  (data) ->
          # Now that we have our data, we update the form so it contains all
          # the needed data to sign the request
          uploader.find('input[name=key]').val(String(data.key))
          uploader.find('input[name=policy]').val(String(data.policy))
          uploader.find('input[name=signature]').val(String(data.signature))

      prevUpload.abort() if prevUpload
      prevUpload = data.submit()

    send: (e, data) ->
      preview.find('img').remove()
      progress.find('.progress').fadeIn(100)

    progress: (e, data) ->
      # This is what makes everything really cool, thanks to that callback
      # you can now update the progress bar based on the upload progress
      percent = Math.round((e.loaded / e.total) * 100)
      progress.find('.progress-bar').css('width', percent + '%')

    fail: (e, data) ->
      console.log(e, data)

    success: (data) ->
      if data.indexOf('<?xml') is -1
        url = uploader.attr('action') + '/' + data.split('&')[1].split('=')[1]
      else
      # Here we get the file url on s3 in an xml doc
        url = $(data).find('Location').text()
      # Update the real input in the other form
      hidden.val(decodeURIComponent(url))
      hidden[0].dispatchEvent agt.domEvent 'fileUpload:success'

      img = $('<img>');
      img.attr('src', decodeURIComponent(url))
      img.prependTo(preview)

      $block.addClass('compact')

    done: (event, data) ->
      # progress.find('.progress').fadeOut 300, ->
      #   progress.find('.progress-bar').css('width', 0)

  i++
