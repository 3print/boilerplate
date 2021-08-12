widgets.define('remote_toggle', function(el) {
  let $el = $(el);
  let method = $el.data('method');
  let url_on = $el.data('url-on');
  let url_off = $el.data('url-off');
  let class_on = $el.data('class-on');
  let class_off = $el.data('class-off');
  let initial = $el.data('initial');
  let handle = window[$el.data('handle')];
  let init = window[$el.data('init')];

  let [current_url, current_listener] = Array.from([]);

  let on_listener = function(data) {
    $el.removeClass(class_off).addClass(class_on);
    current_url = url_off;
    current_listener = off_listener;
    return (typeof handle === 'function' ? handle(data, $el) : undefined);
  };

  var off_listener = function(data) {
    $el.removeClass(class_on).addClass(class_off);
    current_url = url_on;
    current_listener = on_listener;
    return (typeof handle === 'function' ? handle(data, $el) : undefined);
  };

  let on_error = function(data) {
    if (data.errors != null) {
      return (() => {
        let result = [];
        for (let k in data.errors) {
          let v = data.errors[k];
          result.push($el.before(`\
<span class='alert alert-danger alert-dismissible'>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    ${v}
</span>\
`
          ));
        }
        return result;
      })();
    }
  };

  if (initial === 'on') {
    $el.addClass(class_on);
    current_url = url_off;
    current_listener = off_listener;
  } else {
    $el.addClass(class_off);
    current_url = url_on;
    current_listener = on_listener;
  }

  $el.on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $el.parent().find('.alert').remove();
    $el.addClass('loading');

    return $.ajax({
      method,
      url: current_url,
      success: current_listener,
      dataType: 'json',
      complete(xhr) {
        if (xhr.status >= 400) { on_error(JSON.parse(xhr.responseText)); }
        return $el.removeClass('loading');
      }
    });
});

  return (typeof init === 'function' ? init($el) : undefined);
});
