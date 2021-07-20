
let id = 0;

class SettingsImageUploader {
  constructor(uploader) {
    this.editor = $(uploader);
    this.clear_button = this.editor.find('.btn-danger');
    this.active_area = this.editor.find('.controls label');
    this.preview = this.editor.find('.preview');
    this.input = this.editor.find('input');
    this.progress = this.editor.find('.progress');
    this.progress_bar = this.progress.find('.progress-bar');

    if (this.input.val() === '') { this.clear(); }

    this.active_area.click(e=> {
      e.preventDefault();
      this.uploadFile();
      return false;
    });

    this.clear_button.click(e=> {
      e.preventDefault();
      this.clear();
      return false;
    });
  }

  uploadFile() {
    let uploader  = $('.direct-upload').first().clone();
    uploader.insertAfter($('.direct-upload').first());
    let redirect_url = document.location.protocol + '//' + document.location.host + '/result.html';

    let $file_field = uploader.find('input[type="file"]');
    $file_field.attr('id', `settings-image-uploader-${id}`);

    let is_ie = $('html').hasClass('ie9') || $('html').hasClass('lt-ie9');

    $(uploader).fileupload({
      url:          uploader.attr('action'),
      type:         'POST',
      autoUpload:   true,
      sequentialUploads: true,
      crossDomain: true,
      redirect: is_ie ? redirect_url : undefined,
      redirectParamName: is_ie ? 'success_action_redirect' : undefined,
      forceIframeTransport: is_ie,

      // This is really important as s3 gives us back the url of the file in a XML document
      // dataType:     'xml',
      dataType:     'text',

      add(event, data) {
        let prevUpload;
        let signed_data = {
          doc: {
            title: data.files[0].name
          }
        };

        if (is_ie) { signed_data['success_action_redirect'] = redirect_url; }

        $.ajax({
          url:      '/signed_urls',
          type:     'GET',
          dataType: 'json',
          async:    false,

          // send the file name to the server so it can generate the key param
          data: signed_data,

          success(data) {
            // Now that we have our data, we update the form so it contains all
            // the needed data to sign the request
            uploader.find('input[name=key]').val(String(data.key));
            uploader.find('input[name=policy]').val(String(data.policy));
            return uploader.find('input[name=signature]').val(String(data.signature));
          }
        });

        if (prevUpload) { prevUpload.abort(); }
        return prevUpload = data.submit();
      },

      send: (e, data) => {
        return this.progress_bar.addClass('progress-bar-striped').addClass('active').width('100%');
      },

      progress: (e, data) => {
        if (this.progress_bar.hasClass('progress-bar-striped')) {
          this.progress_bar.removeClass('progress-bar-striped').removeClass('active');
        }

        // This is what makes everything really cool, thanks to that callback
        // you can now update the progress bar based on the upload progress
        let percent = Math.round((e.loaded / e.total) * 100);
        return this.progress_bar.width(percent + '%');
      },

      fail(e, data) {
        return console.log(e, data);
      },

      success: data => {
        let url;
        if (data.indexOf('<?xml') === -1) {
          url = uploader.attr('action') + '/' + data.split('&')[1].split('=')[1];
          return insertImage(url);
        } else {
          // Here we get the file url on s3 in an xml doc
          url = $(data).find('Location').text();
          return this.insertImage(url);
        }
      },

      done: (event, data) => {
        return this.progress_bar.removeClass('progress-bar-striped').removeClass('active').css('width', 0);
      }
    });

    $file_field.trigger('click');

    return id++;
  }

  clear() {
    this.preview.find('img').remove();
    return this.input.val('');
  }

  insertImage(link) {
    let img = $(`<img src='${link}' class='loaded'>`);

    this.preview.find('img').remove();
    this.preview.append(img);
    return this.input.val(link);
  }
}

widgets.define('settings_image_uploader', el => $(el).data('image_uploader', new SettingsImageUploader(el)));
