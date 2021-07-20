import widgets from 'widjet';
import {asArray, parent} from 'widjet-utils';

widgets.define('select2', (options) => (el, widget) => {
  let data, width;
  if (el.style.width !== '') {
    ({ width } = el.style);
  } else {
    width = 'element';
  }

  let sortable = false;

  if (el.dataset.list != null) {
    const datalist = document.querySelector(el.dataset.list);
    data = [];
    asArray(datalist.childNodes).forEach((op, i) => {
      if (op.nodeName == 'OPTGROUP') {
        const sub_options = [];
        asArray(op.childNodes).forEach((opt, i) => {
          sub_options.push({
            id: opt.getAttribute('value'),
            text: opt.innerText,
          });
        });

        data.push({
          id: `g${i}`,
          text: op.getAttribute('label'),
          children: sub_options,
        });
      } else {
        data.push({
          id: op.getAttribute('value'),
          text: op.text,
        });
      }
    });
  }


  if (el.classList.contains('sortable')) {
    sortable = true;
    el.classList.remove('sortable');
  }

  let searchResults = 5;
  if (el.dataset.searchable == 'false') {
    searchResults = 'Infinity';
  }

  let options = {
    width,
    allowClear: true,
    multiple: el.dataset.multiple,
    minimumResultsForSearch: searchResults
  };

  if (data != null) { options.data = data; }

  options.formatResult = window[el.dataset['format-result']];
  options.formatSelection = window[el.dataset['format-selection']];
  options.formatResultCssClass = window[el.dataset['format-result-css-class']];

  const $el = $(el);
  $el.select2(options);
  if (sortable) {
    $el
    .select2("container")
    .find("ul.select2-choices")
    .attr('data-exclude', '.select2-search-field, :not(li)')
    .attr('data-lock-x', 'false')
    .attr('data-order-field', el.dataset['order-field'])
    .addClass('sortable-list')
    .on('sortable:changed', function() {
      $el.select2("onSortStart");
      return $el.select2("onSortEnd");
    });
  }

  let label = el.previousSibling.querySelector('.select2-chosen');
  if (label && label.innerText == '') {
    label.innerText = el.getAttribute('placeholder');
    parent(label, '.select2-container').classList.add('form-control');
  }

  el.classList.remove('form-control');

  const hiddenParent = parent(el, '.hidden')
  if(hiddenParent) {hiddenParent.classList.remove('hidden'); }

  asArray(parent(el, '.form-group').querySelectorAll('.hidden'))
  .forEach(e => e.classList.remove('hidden'));
});
