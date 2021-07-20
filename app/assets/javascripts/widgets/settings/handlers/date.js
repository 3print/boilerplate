let {additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils;

let get_handler = function(type) {
  return {
    type,
    match(v) { return (v === type) || (v.type === type); },
    fake_value() { return new Date(); },
    save(hidden) {
      let data = collect_setting_data(type, hidden, 'required');
      return hidden.value = format_setting_data(data);
    },

    additional_fields(value, hidden) {
      let on_update = () => this.save(hidden);
      let fields = $(required_field(hidden));
      additional_field('required', value, hidden, fields, on_update);
      return fields;
    }
  };
};

SettingsEditor.handlers.push(get_handler('date'));
SettingsEditor.handlers.push(get_handler('datetime'));
SettingsEditor.handlers.push(get_handler('time'));
