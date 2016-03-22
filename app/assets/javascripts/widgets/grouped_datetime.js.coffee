
to_date = (m) -> new Date(m.toISOString())

computeOffset = (start, end) ->
  return unless end.val()

  start_date = to_date start.data('DateTimePicker').date()
  end_date = to_date end.data('DateTimePicker').date()

  end_date - start_date

widgets.define 'grouped_datetime', (el) ->
  $el = $(el)
  $hidden = $el.parent().find(['[type="hidden"]'])
  $parent = $($el.data('parent-date'))

  offset = computeOffset($parent, $el)

  $el.on 'dp.change', ->
    offset = computeOffset($parent, $el)

  $parent.on 'dp.change', ->
    if offset?
      end = $parent.data('DateTimePicker').date()
      end.add(offset, 'ms')

      $el.data('DateTimePicker').date(end)

      offset = computeOffset($parent, $el)
