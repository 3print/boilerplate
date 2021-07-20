widgets.define('auto_resize', function(el) {
  let resize = function(txt) {
    if (!txt) { return; }
    let $txt = $(txt);
    $txt.height(0);
    return $txt.height(txt.scrollHeight);
  };

  let $this = $(el);
  $this.on('input', function() {
    resize(el);
    return true;
  });

  return setTimeout(() => resize(el)
  , 500);
});
