import {getNode} from 'widjet-utils';
import {
  additionalField,
  requiredField,
  collectSettingData,
  formatSettingData,
} from '../utils';

export default {
  type: 'image',
  match(v) { return (v === 'image') || (v.type === 'image'); },
  fakeValue() { return ''; },
  save(hidden) {
    const data = collectSettingData('image', hidden, 'required');
    hidden.value = formatSettingData(data);
  },
  additionalFields(value, hidden) {
    const field = getNode(requiredField(hidden));
    additionalField('required', value, hidden, field, () => {
      this.save(hidden)
    });
    return [field];
  }
};
