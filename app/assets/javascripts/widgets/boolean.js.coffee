widgets.define 'boolean', (el) ->
  $this = $(el)
  $this.find('input[type=checkbox]').after($this.find 'label')
