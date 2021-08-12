widgets.define('select_url', function(el) {
  let $el = $(el);

  return $el.on('change', function() {
    let url = $el.val();

    if (url !== '') { return document.location = url; }
  });
});
