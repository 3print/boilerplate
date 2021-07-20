let strip = s => s.replace(/^\s+|\s+$/g, '');
let is_json = s => s.match(/^\{|^\[/);
let no_empty_string = function(s) { if (strip(s) === '') { return undefined; } else { return s; } };
let to_array = v => String(v).split(',').map(strip);
let light_unescape = str =>
  str
  .replace(/&lt;/g, '<')
  .replace(/&gt;/g, '>')
  .replace(/\\"/g, '"')
;
let is_boolean_field = function(field) {
  let type = field.attr('type');
  return (type === 'checkbox') || (type === 'radio');
};

let additional_field = function(name, value, hidden, fields, on_update) {
  let field = fields.find(`[data-name='${name}']`);
  hidden[`${name}_input`] = field;

  field.on('change', on_update);

  if (is_boolean_field(field)) {
    if (value[name]) { return field.attr('checked', 'checked'); }
  } else {
    return field.val(value[name]);
  }
};

let required_field = hidden =>
  `\
<div class="form-group">
  <div class="controls">
    <label for="${hidden.id}_required">
      <input
        type="checkbox"
        class="form-check-input"
        id="${hidden.id}_required"
        data-name="required">
      </input>
      ${"settings_input.required.label".t()}
    </label>
  </div>
</div>\
`
;

let collect_setting_data = function(type, hidden, ...fields) {
  let data = {type};

  for (let field of Array.from(fields)) {
    let input = hidden[`${field}_input`];
    if (is_boolean_field(input)) {
      if (input.is(':checked')) { data[field] = true; }
    } else {
      let value = no_empty_string(input.val());
      if (value != null) { data[field] = value; }
    }
  }

  return data;
};

let format_setting_data = function(data) {
  if (Object.keys(data).length === 1) {
    return data.type;
  } else {
    return JSON.stringify(data);
  }
};

let Cls = (window.SettingsEditor = class SettingsEditor {
  static initClass() {
    this.Utils = {
      strip,
      is_json,
      no_empty_string,
      to_array,
      light_unescape,
      additional_field,
      required_field,
      collect_setting_data,
      format_setting_data
    };
  
    this.handlers = [];
  }

  static handlers_by_type() { let o = {}; for (let h of Array.from(this.handlers)) { o[h.type] = h; } return o; }

  static handler_for_type(type) { return this.handlers_by_type()[type]; }

  static handler_for_type_or_value(type) {
    let left;
    return (left = this.handler_for_type(type)) != null ? left : this.handler_for_value(type);
  }

  static handler_for_value(value) {
    let res = this.handlers.filter(h => typeof h.match === 'function' ? h.match(value) : undefined);
    return res[0];
  }

  constructor(table) {
    this.append_row = this.append_row.bind(this);
    this.table = table;
    this.add_button = this.table.querySelector('.add');
    this.row_blueprint = light_unescape(this.table.dataset.rowBlueprint);
    this.form = document.querySelector('form');

    let rows = this.table.querySelectorAll('tr');
    this.num_rows = rows.length;

    Array.prototype.forEach.call(rows, row => {
      let hidden = row.querySelector('input[type=hidden]');
      if (hidden == null) { return; }

      this.initialize_type(row, hidden);
      return this.register_row_events(row);
    });

    this.register_events();
  }

  fake_form_values(field_prefix) {
    let form_fields = [];

    Array.prototype.forEach.call(this.table.querySelectorAll('tbody tr'), row => {
      let old_input = row.querySelector('input[type=hidden]');

      if (old_input == null) { return; }

      let name = row.querySelector('input[type=text]').value;
      let type = old_input.value;

      let value = this.get_value_for_type(type);

      let new_field = document.createElement('input');
      new_field.type = 'hidden';
      new_field.name = `${field_prefix}[${name}]`;
      new_field.value = value;

      return form_fields.push(new_field);
    });

    return form_fields;
  }

  get_value_for_type(type) {
    let left;
    return (left = __guardMethod__(this.constructor.handler_for_type(type), 'fake_value', o => o.fake_value())) != null ? left : '';
  }

  append_row(e) {
    e.preventDefault();

    let row = $(this.row_blueprint)[0];
    let hidden = row.querySelector('input[type=hidden]');
    hidden.id += this.num_rows++;

    this.initialize_type(row, hidden);
    this.register_row_events(row);

    let last_row = this.table.querySelector('tbody tr:last-child');
    this.table.querySelector('tbody').insertBefore(row, last_row);

    return $(row).trigger('nested:fieldAdded');
  }

  initialize_type(row, hidden, value) {
    let additional = row.querySelector('.additional');
    additional.innerHTML = '';

    let original_value = value != null ? value : hidden.value;
    if (is_json(original_value)) { original_value = JSON.parse(original_value); }

    let original_type = this.constructor.handler_for_type_or_value(original_value);

    if (original_type != null) {
      if (value == null) {
        let $select = $(row.querySelector('select'));
        $select.val(original_type.type).trigger('change');
      }

      let fields = typeof original_type.additional_fields === 'function' ? original_type.additional_fields(original_value, hidden) : undefined;

      if (fields != null) { $(additional).append(fields); }

      if (value != null) { original_type.save(hidden); }
    }

    return setTimeout(() => $(row).trigger('nested:fieldAdded')
    , 100);
  }

  register_row_events(row) {
    let $row = $(row);
    let $hidden = $row.find('input[type=hidden]').first();
    let $input = $row.find('input[type=text]').first();
    let $select = $row.find('select');
    let $remove = $row.find('.remove');

    if (!($hidden.length > 0)) { return; }

    $select.on('change', () => {
      return this.initialize_type(row, $hidden[0], $select.val());
    });

    $input.on('change input', () => {
      if (this.validate($input.val())) {
        return $hidden.attr('name', `${$(this.table).data('model')}[${this.table.getAttribute('data-attribute-name')}][${$input.val()}]`);
      }
    });

    return $remove.on('click', function(e) {
      e.preventDefault();
      return $row.remove();
    });
  }

  validate(value) { return /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(value); }

  register_events() {
    return $(this.add_button).on('click', this.append_row);
  }
});
Cls.initClass();

function __guardMethod__(obj, methodName, transform) {
  if (typeof obj !== 'undefined' && obj !== null && typeof obj[methodName] === 'function') {
    return transform(obj, methodName);
  } else {
    return undefined;
  }
}