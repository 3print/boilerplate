widgets.define('remote_link', function(el) {
  let $el = $(el);
  let method = $el.data('method');
  let url = $el.attr('href');
  let handle = window[$el.data('handle')];

  let listener = data => typeof handle === 'function' ? handle(data, $el) : undefined;

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

  return $el.on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $el.parent().find('.alert').remove();
    $el.addClass('loading');

    return $.ajax({
      method,
      url,
      success: listener,
      dataType: 'json',
      complete(xhr) {
        if (xhr.status >= 400) { on_error(JSON.parse(xhr.responseText)); }
        return $el.removeClass('loading');
      }
    });
});
});
