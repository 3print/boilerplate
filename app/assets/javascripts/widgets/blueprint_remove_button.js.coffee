widgets.define 'blueprint_remove_button', (el, options={}) ->
  $(el).click ->
    $this = $(@)
    $target = $($this.data('remove'))
    no_update_index = $this.data('no-update-index')

    unless no_update_index
      index = $target.index()

      $next = $target.next()
      while $next.length
        $next.attr('id', $next.attr('id').replace(/_\d_/g, "_#{index}_")).html().replace(/_\d_/g, "_#{index}_").replace(/\]\[\d\]\[/g, "][#{index}][")
        with_widgets = $next.find('[class*="-handled"]')

        with_widgets.each ->
          $this = $(@)
          classes_to_remove = $this.attr('class').split(/\s+/).filter (c) ->
            c.match /-handled$/

          $this.removeClass(c) for c in classes_to_remove
        index += 1
        $next = $next.next()

    $parent = $target.parent()
    $target.remove()
    $parent.trigger('nested:fieldRemoved')
