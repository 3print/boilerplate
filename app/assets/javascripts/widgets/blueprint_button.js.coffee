
widgets.define 'blueprint_button', (el) ->
  $this = $(el)
  blueprint = $this.data('blueprint') or $($this.data('blueprint-selector')).data('blueprint')
  $target = $($this.data('target'))

  $this.click ->
    $target.append(blueprint.replace(/\{index\}/g, $target.children().length)).trigger('nested:fieldAdded')
