import widgets from 'widjet';
import {getNode} from 'widjet-utils';
import moment from 'moment';
import {DisposableEvent} from 'widjet-disposables';

function defineWidget(name, constantKey) {
  widgets.define(name, (options) => (el, widget) => {
    let date;

    if ((date = moment(el.value, window[`${constantKey}_DISPLAY_FORMAT`])).isValid()) {
      el.value = date.format(window[`${constantKey}_FORMAT`]);
    }

    const disposable = new DisposableEvent(el, 'change', (e) => {
      if ((date = moment(el.value, window[`${constantKey}_DISPLAY_FORMAT`])).isValid()) {
        el.value = date.format(window[`${constantKey}_FORMAT`]);
      }
    });

    $(el).datetimepicker({
      format: window[`${constantKey}_FORMAT`],
      displayFormat: window[`${constantKey}_DISPLAY_FORMAT`],
      locale: window.I18n.locale,
      // inline: true
      calendarWeeks: true,
      sideBySide: true
    });

    return disposable;
  });
}

defineWidget('datepicker', 'DATE');
defineWidget('datetimepicker', 'DATETIME');
defineWidget('timepicker', 'TIME');

widgets.define('datepicker_mobile', (options) => (el, widget) => {
  let value;

  let type = (() => { switch (true) {
    case el.classList.contains('datetimepicker'): return 'datetime';
    case el.classList.contains('datepicker'): return 'date';
    case el.classList.contains('timepicker'): return 'time';
  } })();

  if (el.value !== '') {
    value = new Date(el.value).toISOString();
  } else {
    value = '';
  }

  let handler = getNode(`<input type='${type}' value='${value}' class='form-control'></input>`);

  if (el.hasAttribute('name')) {
    handler.setAttribute('name', el.getAttribute('name'));
  }
  if (el.hasAttribute('placeholder')) {
    handler.setAttribute('placeholder', el.getAttribute('placeholder'));
  }

  el.parentNode.insertBefore(handler, el.nextSibling);
  el.remove();
});
