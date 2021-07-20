widgets.define('field_limit', function(el) {
  let limit = Number(el.getAttribute('data-limit'));

  if ((limit == null) || (limit === 0)) { return; }

  let result = document.createElement('div');
  result.textContent = `Caractères restant : ${limit - el.value.length}`;

  let check = function() {
    result.textContent = `Caractères restant : ${limit - el.value.length}`;

    if (el.value.length > limit) {
      return result.className = 'text-danger';
    } else {
      return result.className = 'text-success';
    }
  };

  el.parentNode.appendChild(result);

  el.addEventListener('input', check);
  el.addEventListener('change', check);

  return check();
});
