import widgets from 'widjet';
import {asArray, getNode, parent} from 'widjet-utils';
import {CompositeDisposable, DisposableEvent} from 'widjet-disposables';

widgets.define('order-table', (options) => (el) => {
  const table = el.querySelector('table');
  const tableBody = table.querySelector('tbody');
  const rows = asArray(tableBody.querySelectorAll('tr'));

  const bounds = table.getBoundingClientRect();

  let start = null;
  let dragOffset = null;
  let originalPos = null;
  let originalIndex = null;
  let lastPlaceholderIndex = null;
  let dragging = false;
  let parentNode = null;
  let dragged = null;
  let placeholder = null;

  const px = (s) => `${s}px`;

  function startDrag(e, el) {
    originalPos = el.getBoundingClientRect();
    lastPlaceholderIndex = (originalIndex = rows.indexOf(el));
    dragging = true;
    dragOffset = {
      left: originalPos.left - e.pageX,
      top: originalPos.top - e.pageY,
    };

    parentNode = el.parentNode;
    placeholder = getNode(`<tr class='dnd-placeholder'><td colspan='${el.children.length}'></td></tr>`, 'tbody');
    placeholder.style.height = px(el.offsetHeight);

    asArray(el.querySelectorAll('td')).forEach((td) => {
      td.style.width = px(td.offsetWidth);
    });

    el.parentNode.insertBefore(placeholder, el);
    el.remove();

    dragged = getNode(`<table class='${table.className} dragged'/>`);
    dragged.style.position = 'absolute';
    dragged.style.width = px(table.offsetWidth);
    dragged.style.left = px(table.offsetLeft);
    dragged.appendChild(el);
    document.body.appendChild(dragged);
  }

  function drag(e) {
    const b = dragged.getBoundingClientRect()
    dragged.style.left = px(originalPos.left);
    dragged.style.top = px(
      Math.min(
        bounds.bottom - b.height,
        Math.max(
          bounds.top,
          e.pageY + dragOffset.top
        )
      )
    );
    const targetRow = parent(e.target, 'tr');
    if (!targetRow) { return; }
    if (!targetRow.matches('tbody > tr')) { return; }

    const rows = asArray(tableBody.querySelectorAll('tr'));
    const targetIndex = rows.indexOf(targetRow);

    if ((targetIndex !== lastPlaceholderIndex) && targetRow.matches(':not(.dnd-placeholder)')) {
      if (targetIndex < lastPlaceholderIndex) {
        targetRow.parentNode.insertBefore(placeholder, targetRow);
      } else {
        targetRow.parentNode.insertBefore(placeholder, targetRow.nextSibling);
      }

      lastPlaceholderIndex = targetIndex;
    }
  }

  function stopDrag(e, el, aborted) {
    let targetIndex;
    if (aborted == null) { aborted = false; }
    const targetRow = parent(e.target, 'tr');
    if (!targetRow) { aborted = true; }
    const rows = asArray(tableBody.querySelectorAll('tr'));

    if (aborted) {
      targetIndex = originalIndex;
    } else {
      targetIndex = rows.indexOf(targetRow);
    }

    const row = rows[targetIndex];
    if(row) {
      tableBody.insertBefore(el, row);
    } else {
      tableBody.appendChild(el);
    }

    placeholder.remove();
    dragged.remove();
    updateSequence();
  };

  function updateSequence () {
    const rows = asArray(tableBody.querySelectorAll('tr'));
    rows.forEach((row, i) => {
      const field = row.querySelector(el.dataset.orderField);
      field.value = i + 1;
    });
  }

  return new CompositeDisposable(rows.map((row, i) => {
    return new DisposableEvent(row, 'mousedown', (e) => {
      if (e.target.matches('a')) { return; }

      e.preventDefault();

      start = {left: e.pageX, top: e.pageY};

      const mousemove = (e) => {
        if (!dragging) {
          const difX = e.pageX - start.left;
          const difY = e.pageY - start.top;

          if (Math.abs(Math.sqrt((difX * difX) + (difY * difY))) > 10) {
            startDrag(e, row);
          }
        } else {
          drag(e);
        }
      };

      const mouseup = (e) => {
        if (dragging) {
          stopDrag(e, row);
          dragging = false;
        }

        window.removeEventListener('mouseup', mouseup);
        window.removeEventListener('mousemove', mousemove);
      };

      window.addEventListener('mouseup', mouseup);
      window.addEventListener('mousemove', mousemove);
    });
  }));
});

    // $row.on 'touchstart', (e) ->
    //   e.preventDefault()
    //   timeout = setTimeout ->
    //     timeout = null
    //     start_drag(e, $row)
    //   , 1000
    //
    //   $row.on 'touchend', (e) ->
    //     if timeout
    //       clearTimeout(timeout)
    //     else
    //       stopDrag(e, $row)
    //
    //   $row.on 'touchmove', (e) ->
    //     if dragging
    //       e.preventDefault()
    //       drag(e)
