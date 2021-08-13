import {getNodes} from 'widjet-utils';
import {
  additionalField,
  collectSettingData,
  requiredField,
  toArray,
} from '../utils';

export default {
  type: 'collection',
  match(v) {
    return ((typeof v === 'string') && (v.indexOf(',') >= 0)) || (v.type === 'collection');
  },
  fakeValue() { return ['foo','bar','baz']; },
  save(hidden) {
    const data = collectSettingData('collection', hidden, 'required', 'multiple');
    data.values = toArray(hidden.values_input.value);
    return hidden.value = JSON.stringify(data);
  },

  additionalFields(value, hidden) {
    const onUpdate = () => this.save(hidden);

    value = (value.values != null) ? value : {values: toArray(value)};
    const fields = getNodes(`\
<div class="form-group">
  <label for="${hidden.id}_collection_values">${'settings_input.collection.values.label'.t()}</label>
  <div class="controls">
    <input type="text"
           class="form-control"
           id="${hidden.id}_collection_values"
           data-name="values"
           placeholder="${'settings_input.collection.values.placeholder'.t()}"
           required>
    </input>
  </div>
</div>\
<div class="row">
  <div class="col-sm-6">
    ${requiredField(hidden)}
  </div>
  <div class="col-sm-6">
    <div class="form-group">
      <div class="controls">
        <input
          type="checkbox"
          class="form-check-input"
          id="${hidden.id}_multiple"
          data-name="multiple">
        </input>
        <label for="${hidden.id}_multiple">${"settings_input.collection.multiple.label".t()}</label>
      </div>
    </div>
  </div>
</div>`);

    additionalField('values', value, hidden, fields[0], onUpdate);
    additionalField('required', value, hidden, fields[1], onUpdate);
    additionalField('multiple', value, hidden, fields[1], onUpdate);

    return fields;
  }
};
