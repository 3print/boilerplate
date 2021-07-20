let {additional_field, required_field, collect_setting_data, format_setting_data} = SettingsEditor.Utils;

SettingsEditor.handlers.push({
  type: 'string',
  match(v) { return (v === 'string') || (v.type === 'string'); },
  fake_value() { return 'preview string'; },
  save(hidden) {
    let data = collect_setting_data('string', hidden, 'required', 'textarea', 'limit');
    return hidden.value = format_setting_data(data);
  },
  additional_fields(value, hidden) {
    let on_update = () => this.save(hidden);
    let html = `\
<div class="row">
  <div class="col-sm-3">
    ${required_field(hidden)}
  </div>
  <div class="col-sm-3">
    <div class="form-group">
      <div class="controls">
        <label for="${hidden.id}_textarea">
          <input
            type="checkbox"
            class="form-check-input"
            id="${hidden.id}_textarea"
            data-name="textarea">
          </input>
          ${"settings_input.string.textarea.label".t()}
        </label>
      </div>
    </div>
  </div>
  <div class="col-sm-6">
    <div class="form-group">
      <div class="controls">
        <label for="${hidden.id}_limit">${"settings_input.string.limit.label".t()}</label>
        <input
          type="number"
          class="form-control"
          step="1"
          id="${hidden.id}_limit"
          placeholder="${"settings_input.string.limit.placeholder".t()}"
          data-name="limit">
        </input>
      </div>
    </div>
  </div>
</div>\
`;

    let fields = $(html);

    additional_field('required', value, hidden, fields, on_update);
    additional_field('textarea', value, hidden, fields, on_update);
    additional_field('limit', value, hidden, fields, on_update);

    return fields;
  }
});

SettingsEditor.handlers.push({
  type: 'markdown',
  match(v) { return (v === 'markdown') || (v.type === 'markdown'); },
  fake_value() { return 'preview string'; },
  save(hidden) {
    let data = collect_setting_data('markdown', hidden, 'required');
    return hidden.value = format_setting_data(data);
  },
  additional_fields(value, hidden) {
    let on_update = () => this.save(hidden);
    let fields = $(required_field(hidden));
    additional_field('required', value, hidden, fields, on_update);
    return fields;
  }
});
