
widgets.define('blueprint_button', function(el) {
  let $this = $(el);
  let blueprint = $this.data('blueprint') || $($this.data('blueprint-selector')).data('blueprint');
  let $target = $($this.data('target'));

  return $this.click(() => $target.append(blueprint.replace(/\{index\}/g, $target.children().length)).trigger('nested:fieldAdded'));
});
