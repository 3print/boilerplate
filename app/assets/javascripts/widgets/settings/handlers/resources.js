let {additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils;

SettingsEditor.handlers.push({
  type: 'resource',
  match(v) { return (v === 'resource') || (v.type === 'resource'); },
  fake_value() { return ''; },
  save(hidden) {
    let data = collect_setting_data('resource', hidden, 'required');
    return hidden.value = format_setting_data(data);
  },
  additional_fields(value, hidden) {
    let on_update = () => this.save(hidden);
    let fields = $(required_field(hidden));
    additional_field('required', value, hidden, fields, on_update);
    return fields;
  }
});
