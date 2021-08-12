import widgets from 'widjet';
import {asArray, getNode} from 'widjet-utils';
import {isJSON} from 'widjet-json-form/lib/utils';
import {DisposableEvent, CompositeDisposable} from 'widjet-disposables';
import BOOLEAN_HANDLER from './handlers/boolean';
import COLLECTION_HANDLER from './handlers/collection';
import DATE_HANDLER from './handlers/date';
import IMAGE_HANDLER from './handlers/image';
import NUMBER_HANDLER from './handlers/numbers'
import RESOURCE_HANDLER from './handlers/resources'
import {STRING_HANDLER, MARKDOWN_HANDLER} from './handlers/strings';
import {lightUnescape} from './utils';

export default class SettingsEditor {
  static initClass() {
    this.handlers = [
      BOOLEAN_HANDLER,
      COLLECTION_HANDLER,
      DATE_HANDLER('date'),
      DATE_HANDLER('datetime'),
      DATE_HANDLER('time'),
      IMAGE_HANDLER,
      NUMBER_HANDLER('integer'),
      NUMBER_HANDLER('float'),
      RESOURCE_HANDLER,
      STRING_HANDLER,
      MARKDOWN_HANDLER,
    ];
  }

  static handlersByType() {
    return this.handlers.reduce((m, h) => {
      m[h.type] = h;
      return m;
    }, {});
  }

  static handlerForType(type) {
    return this.handlersByType()[type];
  }

  static handlerForTypeOrValue(type) {
    const handler = this.handlerForType(type);
    return handler ? handler : this.handlerForValue(type);
  }

  static handlerForValue(value) {
    const res = this.handlers.filter(h => typeof h.match === 'function' ? h.match(value) : undefined);
    return res[0];
  }

  constructor(table) {
    this.table = table;
    this.addButton = this.table.querySelector('.add');
    this.rowBlueprint = lightUnescape(this.table.dataset.rowBlueprint);
    this.form = document.querySelector('form');

    const rows = asArray(this.table.querySelectorAll('tr'));
    this.numRows = rows.length;

    rows.forEach((row) => {
      const hidden = row.querySelector('input[type=hidden]');
      if (hidden == null) { return; }

      this.initializeType(row, hidden);
      this.registerRowEvents(row);
    });

    this.registerEvents();
  }

  fakeFormValues(fieldPrefix) {
    const formFields = [];

    asArray(this.table.querySelectorAll('tbody tr')).forEach((row) => {
      const oldInput = row.querySelector('input[type=hidden]');

      if (oldInput == null) { return; }

      const name = row.querySelector('input[type=text]').value;
      const type = oldInput.value;

      const value = this.getValueForType(type);

      const newField = document.createElement('input');
      newField.type = 'hidden';
      newField.name = `${fieldPrefix}[${name}]`;
      newField.value = value;

      formFields.push(newField);
    });

    return formFields;
  }

  getValueForType(type) {
    const handler = this.constructor.handlerForType(type);
    return handler ? handler.fakeValue() : '';
  }

  appendRow(e) {
    e.preventDefault();
    const row = getNode(this.rowBlueprint, 'tbody');
    const hidden = row.querySelector('input[type="hidden"]');
    hidden.id += this.numRows++;

    this.initializeType(row, hidden);
    this.registerRowEvents(row);

    const lastRow = this.table.querySelector('tbody tr:last-child');
    this.table.querySelector('tbody').insertBefore(row, lastRow);
  }

  initializeType(row, hidden, value) {
    const additional = row.querySelector('.additional');
    additional.innerHTML = '';

    let originalValue = value != null ? value : hidden.value;
    if (isJSON(originalValue)) {
      originalValue = JSON.parse(originalValue);
    }

    const originalType = this.constructor.handlerForTypeOrValue(originalValue);

    if (originalType != null) {
      if (value == null) {
        const select = row.querySelector('select');
        select.value = originalType.type;
        widgets.dispatch(select, 'change');
      }

      const fields = typeof originalType.additionalFields === 'function'
        ? originalType.additionalFields(originalValue, hidden)
        : undefined;

      if (fields != null) {
        fields.forEach((f) => additional.appendChild(f));
      }

      if (value != null) { originalType.save(hidden); }
    }

    requestAnimationFrame(() => widgets.dispatch(row, 'nested:fieldAdded'));
  }

  registerRowEvents(row) {
    const hidden = row.querySelector('input[type="hidden"]');
    const input = row.querySelector('input[type="text"]');
    const select = row.querySelector('select');
    const remove = row.querySelector('.remove');

    if (!hidden) { return; }

    return new CompositeDisposable([
      new DisposableEvent(select, 'change', () => {
        this.initializeType(row, hidden, select.value);
      }),
      new DisposableEvent(input, 'change input', () => {
        if (this.validate(input.value)) {
          hidden.setAttribute('name', `${this.table.dataset.model}[${this.table.getAttribute('data-attribute-name')}][${input.value}]`);
        }
      }),
      new DisposableEvent(remove, 'click', (e) => {
        e.preventDefault();
        row.remove();
      }),
    ]);
  }

  validate(value) { return /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(value); }

  registerEvents() {
    return new DisposableEvent(this.addButton, 'click', (e) => this.appendRow(e));
  }
};

SettingsEditor.initClass();
