import {getNode} from 'widjet-utils';
import {
  additionalField,
  requiredField,
  collectSettingData,
  formatSettingData,
} from '../utils';

export const STRING_HANDLER = {
  type: 'string',
  match(v) { return (v === 'string') || (v.type === 'string'); },
  fakeValue() { return 'preview string'; },
  save(hidden) {
    const data = collectSettingData('string', hidden, 'required', 'textarea', 'limit');
    hidden.value = formatSettingData(data);
  },
  additionalFields(value, hidden) {
    const onUpdate = () => this.save(hidden);
    const html = `\
<div class="row">
  <div class="col-sm-3">
    ${requiredField(hidden)}
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

    let field = getNode(html);

    additionalField('required', value, hidden, field, onUpdate);
    additionalField('textarea', value, hidden, field, onUpdate);
    additionalField('limit', value, hidden, field, onUpdate);

    return [field];
  }
};

export const MARKDOWN_HANDLER = {
  type: 'markdown',
  match(v) { return (v === 'markdown') || (v.type === 'markdown'); },
  fakeValue() { return 'preview string'; },
  save(hidden) {
    const data = collectSettingData('markdown', hidden, 'required');
    hidden.value = formatSettingData(data);
  },
  additionalFields(value, hidden) {
    const field = getNode(requiredField(hidden));
    additionalField('required', value, hidden, field, () => {
      this.save(hidden);
    });
    return [field];
  }
};
