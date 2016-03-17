
id = 0

class SettingsImageUploader
  constructor: (uploader) ->
    @editor = $(uploader)
    @clear_button = @editor.find('.btn-danger')
    @active_area = @editor.find('.controls label')
    @preview = @editor.find('.preview')
    @input = @editor.find('input')

    @clear() if @input.val() is ''

    @active_area.click (e)=>
      e.preventDefault()
      @uploadFile()
      false

    @clear_button.click (e)=>
      e.preventDefault()
      @clear()
      false

  uploadFile: ->
    uploader  = $('.direct-upload').first().clone()
    uploader.insertAfter($('.direct-upload').first())
    redirect_url = document.location.protocol + '//' + document.location.host + '/result.html'
    progress = @editor.find('.progress')

    $file_field = uploader.find('input[type="file"]')
    $file_field.attr('id', "settings-image-uploader-#{id}")

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
          url:      '/signed_urls'
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
        progress.find('.progress-bar').css('width', '5%')
        progress.fadeIn(100)

      progress: (e, data) ->
        # This is what makes everything really cool, thanks to that callback
        # you can now update the progress bar based on the upload progress
        percent = 5 + Math.round((e.loaded / e.total) * 95)
        progress.find('.progress-bar').css('width', percent + '%')

      fail: (e, data) ->
        console.log(e, data)

      success: (data) =>
        if data.indexOf('<?xml') is -1
          url = uploader.attr('action') + '/' + data.split('&')[1].split('=')[1]
          insertImage(url)
        else
          # Here we get the file url on s3 in an xml doc
          url = $(data).find('Location').text()
          @insertImage(url)

      done: (event, data) ->
        progress.fadeOut 300, -> progress.find('.progress-bar').css('width', 0)

    $file_field.trigger 'click'

    id++

  clear: ->
    @preview.find('img').remove()
    @input.val('')

  insertImage: (link) ->
    img = $("<img src='#{link}' class='loaded'>")

    @preview.find('img').remove()
    @preview.append(img)
    @input.val(link)

widgets.define 'settings_image_uploader', (el) ->
  $(el).data 'image_uploader', new SettingsImageUploader(el)
