widgets.define 'select2', (el) ->
  $el = $(el)
  if el.style.width isnt ''
    width = el.style.width
  else
    width = 'element'

  sortable = false

  if $el.data('list')?
    datalist = $($el.data('list'))
    data = []
    datalist.children().each (i) ->
      $op = $(this)
      if $op.is('optgroup')
        sub_options = []
        $op.children().each ->
          $opt = $(this)
          sub_options.push
            id: $opt.attr('value')
            text: $opt.text()

        data.push
          id: "g#{i}"
          text: $op.attr('label')
          children: sub_options
      else
        data.push
          id: $op.attr('value')
          text: $op.text()


  if $el.hasClass('sortable')
    sortable = true
    $el.removeClass('sortable')

  options = {
    width: width
    allowClear: true
    multiple: $el.data('multiple')
  }

  options.data = data if data?
  options.formatResult = window[$el.data('format-result')]
  options.formatSelection = window[$el.data('format-selection')]
  options.formatResultCssClass = window[$el.data('format-result-css-class')]

  $el.select2(options)
  if sortable
    $el
    .select2("container")
    .find("ul.select2-choices")
    .attr('data-exclude', '.select2-search-field, :not(li)')
    .attr('data-lock-x', 'false')
    .attr('data-order-field', $el.data('order-field'))
    .addClass('sortable-list')
    .on 'sortable:changed', ->
      $el.select2("onSortStart")
      $el.select2("onSortEnd")

  label = $el.prev().find('.select2-chosen')
  label.text($el.attr('placeholder')) if label.text() is 'undefined'
  label.parents('.select2-container').addClass('form-control')
  $el.removeClass('form-control')

  $el.parents('.hidden').removeClass('hidden')
  $el.parents('.form-group').find('.hidden').removeClass('hidden')
