widgets.define 'field_limit', (el) ->
  limit = Number(el.getAttribute('data-limit'))

  return if not limit? or limit is 0

  result = document.createElement('div')
  result.textContent = "Caractères restant : #{limit - el.value.length}"

  check = ->
    result.textContent = "Caractères restant : #{limit - el.value.length}"

    if el.value.length > limit
      result.className = 'text-danger'
    else
      result.className = 'text-success'

  el.parentNode.appendChild(result)

  el.addEventListener('input', check)
  el.addEventListener('change', check)

  check()
