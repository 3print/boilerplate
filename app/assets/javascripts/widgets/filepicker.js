let $file_fields = [];
let i = 0;

widgets.define('filepicker', function(element, options) {
  $.support.cors = true;

  let $element = $(element);
  let preview   = $element.find('.preview').first();
  let hidden    = $element.find('input[type="hidden"]').first();
  let uploader  = $('.direct-upload').first().clone();
  $element.find('label').attr('for', `s3-uploader-${i}`);

  let $file_field = uploader.find('input[type="file"]');
  $file_field.attr('id', `s3-uploader-${i}`);

  let $label = $(`<label for='s3-uploader-${i}'></label>`);
  $element.find('.controls').append($label);

  // return if $(input[0]).attr('id') in $file_fields
  // $file_fields.push $(input[0]).attr('id')

  if (preview.length && uploader.length) {

    uploader.insertAfter($('.direct-upload').first());

    preview.addClass('target-area');
    preview.bind('click', () => uploader.find('input[type="file"]').click());
    let prevUpload = null;

    let image_size = 0;

    let redirect_url = document.location.protocol + '//' + document.location.host + '/result.html';
    let is_ie = $('html').hasClass('ie9') || $('html').hasClass('lt-ie9');

    $(uploader).fileupload({
      url: uploader.attr('action'),
      type: 'POST',
      autoUpload: true,
      sequentialUploads: true,
      crossDomain: true,
      redirect: is_ie ? redirect_url : undefined,
      redirectParamName: is_ie ? 'success_action_redirect' : undefined,
      forceIframeTransport: is_ie,
      dropZone: $element,

      // This is really important as s3 gives us back the url of the file in a XML document
      dataType: 'text',

      add(event, data) {
        image_size = data.files[0].size;
        let signed_data = {
          doc: {
            title: data.files[0].name
          }
        };

        if (is_ie) { signed_data['success_action_redirect'] = redirect_url; }

        return $.ajax({
          url: '/signed_urls',
          type: 'GET',
          dataType: 'json',

          // send the file name to the server so it can generate the key param
          data: signed_data,

          success(sign) {
            // Now that we have our data, we update the form so it contains all
            // the needed data to sign the request
            uploader.find('input[name=key]').val(String(sign.key));
            uploader.find('input[name=policy]').val(String(sign.policy));
            uploader.find('input[name=signature]').val(String(sign.signature));

            if (prevUpload) { prevUpload.abort(); }
            return prevUpload = data.submit();
          }
        });
      },

      send(e, data) {
        preview.find('img').fadeOut();
        return true;
      },

      progress(e, data) {
        // This is what makes everything really cool, thanks to that callback
        // you can now update the progress bar based on the upload progress
        let percent = Math.round((e.loaded / e.total) * 100);
        return preview.find('.progress-bar').css('width', percent + '%');
      },

      fail(e, data) {
        console.log('fail');
        return console.log(JSON.stringify(data));
      },

      success(data) {
        let url;
        if (data.indexOf('<?xml') === -1) {
          url = uploader.attr('action') + '/' + data.split('&')[1].split('=')[1];
        } else {
        // Here we get the file url on s3 in an xml doc
          url = $(data).find('Location').text();
        }

        // Update the real input in the other form
        hidden.val(url);
        preview.find('img').remove();

        if (/\.(png|jpg|jpeg|gif)/i.test(url)) {
          if (preview.find('.label').length === 0) {
            preview.find('.placeholder').remove();
            preview.append(`\
<div class="label label-default"></div>
<div class="meta">
  <div class="dimensions"></div>
  <div class="size"></div>
</div>\
`);
          }

          let label = preview.find('.label');
          let dimensions = preview.find('.dimensions');
          let size = preview.find('.size');

          let img = $('<img>');
          img[0].onload = function() {
            dimensions.html(`\
<span class="number">${img[0].width}</span>x<span class="number">${img[0].height}</span>px\
`);
            return img.addClass('loaded');
          };

          img.attr('src', url);
          img.prependTo(preview);

          label.text(unescape(url).split('/').pop()).attr('title', url);
          return size.html(`\
<span class="number">${Math.round((image_size / 1024) * 100) / 100}</span>ko\
`);
        } else {
          return preview.html(`\
<i class='fa fa-file-pdf-o'></i>
${unescape(url).split('/').pop()}\
`).attr('title', url);
        }
      },

      done(event, data) {
        return preview.find('.progress').fadeOut(300, () => preview.find('.progress-bar').css('width', 0));
      }
    });

  } else {
    let $input = $element.find('input').show();
    let $value = $element.find('.placeholder');

    $input.on('change', function() {
      let value = $input.val();
      if (preview.length) {
        preview.before(`\
<div class='preview'>${value}</div>\
`);
        preview.remove();
        return preview = $element.find('.preview').first();

      } else {
        $value.toggleClass('placeholder', value === '');
        return $value.text(value || 'placeholder');
      }
    });
  }

  return i++;
});
