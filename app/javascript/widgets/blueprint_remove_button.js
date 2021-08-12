widgets.define('blueprint_remove_button', function(el, options) {
  if (options == null) { options = {}; }
  return $(el).click(function() {
    let $this = $(this);
    let $target = $($this.data('remove'));
    let no_update_index = $this.data('no-update-index');

    if (!no_update_index) {
      let index = $target.index();

      let $next = $target.next();
      while ($next.length) {
        $next.attr('id', $next.attr('id').replace(/_\d_/g, `_${index}_`)).html().replace(/_\d_/g, `_${index}_`).replace(/\]\[\d\]\[/g, `][${index}][`);
        let with_widgets = $next.find('[class*="-handled"]');

        with_widgets.each(function() {
          $this = $(this);
          let classes_to_remove = $this.attr('class').split(/\s+/).filter(c => c.match(/-handled$/));

          return (() => {
            let result = [];
            for (let c of Array.from(classes_to_remove)) {               result.push($this.removeClass(c));
            }
            return result;
          })();
        });
        index += 1;
        $next = $next.next();
      }
    }

    let $parent = $target.parent();
    $target.remove();
    return $parent.trigger('nested:fieldRemoved');
  });
});
