import widgets from 'widjet';

widgets.define('table-sort-header', (options) => (el) => {
  const allow_reverse = el.hasAttribute('data-reverse');
  const reversed = el.hasAttribute('data-reversed');

  const title = el.classList.contains('table-active')
    ? allow_reverse && !reversed
      ? el.dataset.titledesc
      : 'widgets.table_header_sort.reset'.t()
    : el.dataset.titleasc;

  const icon = el.classList.contains('table-active')
    ? allow_reverse && !reversed
      ? options.iconDesc
      : options.iconReset
    : options.iconAsc;

  const value = reversed ? '' : el.dataset.sort;

  const btn = document.createElement('button');
  btn.name = 'o';
  btn.className = 'btn btn-outline-secondary btn-sm pull-right';
  btn.title = title;
  btn.value = value;
  btn.innerHTML = icon;

  el.insertBefore(btn, el.firstChild);
});
