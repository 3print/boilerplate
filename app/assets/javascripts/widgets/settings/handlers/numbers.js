import {getNodes} from 'widjet-utils';
import {
  additionalField,
  requiredField,
  collectSettingData,
  formatSettingData,
} from '../utils';

const fields = ['default', 'min', 'max', 'step'];

export default (name) => {
  return {
    type: name,

    match(v) { return (v === name) || (v.type === name); },

    fakeValue() { return Math.round(Math.random() * 100); },

    save(hidden) {
      let data = collectSettingData(name, hidden, 'required', ...Array.from(fields));
      return hidden.value = formatSettingData(data);
    },

    additionalFields(value, hidden) {
      const onUpdate = () => this.save(hidden);

      let html = '<div class="row">';
      fields.forEach((key) => {
        html += `
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
</div>
`
      });
      html += '</div>';
      html += requiredField(hidden);

      const additionalFields = getNodes(html);

      additionalField('required', value, hidden, additionalFields[1], onUpdate);
      fields.forEach(key => {
        additionalField(key, value, hidden, additionalFields[0], onUpdate);
      });

      return additionalFields;
    }
  };
};


