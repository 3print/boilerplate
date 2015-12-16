$file_fields = []
i = 0

widgets.define 'filepicker', (element, options) ->
  $.support.cors = true

  $element = $(element)
  preview   = $element.find('.preview').first()
  hidden    = $element.find('input[type="hidden"]').first()
  uploader  = $('.direct-upload').first().clone()
  $element.find('label').attr('for', "s3-uploader-#{i}")

  $file_field = uploader.find('input[type="file"]')
  $file_field.attr('id', "s3-uploader-#{i}")

  $label = $("<label for='s3-uploader-#{i}'></label>")
  $element.find('.controls').append($label)

  # return if $(input[0]).attr('id') in $file_fields
  # $file_fields.push $(input[0]).attr('id')

  if preview.length and uploader.length

    uploader.insertAfter($('.direct-upload').first())

    preview.addClass('target-area')
    preview.bind 'click', -> uploader.find('input[type="file"]').click()
    prevUpload = null

    image_size = 0

    redirect_url = document.location.protocol + '//' + document.location.host + '/result.html'
    is_ie = $('html').hasClass('ie9') or $('html').hasClass('lt-ie9')

    $(uploader).fileupload
      url: uploader.attr('action')
      type: 'POST'
      autoUpload: true
      sequentialUploads: true
      crossDomain: true
      redirect: redirect_url if is_ie
      redirectParamName: 'success_action_redirect' if is_ie
      forceIframeTransport: is_ie

      # This is really important as s3 gives us back the url of the file in a XML document
      dataType: 'text'

      add: (event, data) ->
        image_size = data.files[0].size
        signed_data =
          doc:
            title: data.files[0].name

        signed_data['success_action_redirect'] = redirect_url if is_ie

        $.ajax
          url: '/signed_urls'
          type: 'GET'
          dataType: 'json'

          # send the file name to the server so it can generate the key param
          data: signed_data

          success:  (sign) ->
            # Now that we have our data, we update the form so it contains all
            # the needed data to sign the request
            uploader.find('input[name=key]').val(String(sign.key))
            uploader.find('input[name=policy]').val(String(sign.policy))
            uploader.find('input[name=signature]').val(String(sign.signature))

            prevUpload.abort() if prevUpload
            prevUpload = data.submit()

      send: (e, data) ->
        preview.find('img').fadeOut()
        true

      progress: (e, data) ->
        # This is what makes everything really cool, thanks to that callback
        # you can now update the progress bar based on the upload progress
        percent = Math.round((e.loaded / e.total) * 100)
        preview.find('.progress-bar').css('width', percent + '%')

      fail: (e, data) ->
        console.log('fail')
        console.log(JSON.stringify(data))

      success: (data) ->
        if data.indexOf('<?xml') is -1
          url = uploader.attr('action') + '/' + data.split('&')[1].split('=')[1]
        else
        # Here we get the file url on s3 in an xml doc
          url = $(data).find('Location').text()

        # Update the real input in the other form
        hidden.val(url)
        preview.find('img').remove()

        if /\.(png|jpg|jpeg|gif)/.test(url)
          if preview.find('.label').length is 0
            preview.find('.placeholder').remove()
            preview.append("""
            <div class="label label-default"></div>
            <div class="meta">
              <div class="dimensions"></div>
              <div class="size"></div>
            </div>
            """)

          label = preview.find('.label')
          dimensions = preview.find('.dimensions')
          size = preview.find('.size')

          img = $('<img>')
          img[0].onload = ->
            dimensions.html("""
              <span class="number">#{img[0].width}</span>x<span class="number">#{img[0].height}</span>px
            """)
            img.addClass('loaded')

          img.attr('src', url)
          img.prependTo(preview)

          label.text(unescape(url).split('/').pop()).attr('title', url)
          size.html("""
            <span class="number">#{Math.round(image_size / 1024 * 100) / 100}</span>ko
          """)
        else
          preview.html("""
            <i class='fa fa-file-pdf-o'></i>
            #{unescape(url).split('/').pop()}
          """).attr('title', url)

      done: (event, data) ->
        preview.find('.progress').fadeOut 300, ->
          preview.find('.progress-bar').css('width', 0)

  else
    $input = $element.find('input').show()
    $value = $element.find('.placeholder')

    $input.on 'change', ->
      value = $input.val()
      $value.toggleClass('placeholder', value is '')
      $value.text(value or 'placeholder')

  i++
