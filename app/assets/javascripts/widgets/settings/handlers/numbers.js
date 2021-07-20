let {additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils;

let fields = ['default', 'min', 'max', 'step'];

let get_handler = function(name) {
  return {
    type: name,

    match(v) { return (v === name) || (v.type === name); },

    fake_value() { return Math.round(Math.random() * 100); },

    save(hidden) {
      let data = collect_setting_data(name, hidden, 'required', ...Array.from(fields));
      return hidden.value = format_setting_data(data);
    },

    additional_fields(value, hidden) {
      let on_update = () => this.save(hidden);

      let html = '<div class="row">';
      fields.forEach(key =>
        html += `\
<div class="col-sm-3">
    <label for="${hidden.id}_${key}">${`settings_input.${name}.${key}.label`.t()}</label>
    <input
      type="number"
      class="form-control"
      id="${hidden.id}_${key}"
      ${name === 'integer' ? 'step="1"' : ''}
      placeholder="${`settings_input.${name}.${key}.placeholder`.t()}"
      data-name="${key}">
    </input>
</div>\
`
      );
      html += '</div>';
      html += required_field(hidden);

      let additional_fields = $(html);

      additional_field('required', value, hidden, additional_fields, on_update);
      fields.forEach(key => additional_field(key, value, hidden, additional_fields, on_update));

      return additional_fields;
    }
  };
};

SettingsEditor.handlers.push(get_handler('integer'));
SettingsEditor.handlers.push(get_handler('float'));
