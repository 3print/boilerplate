import {getNode} from 'widjet-utils';
import {
  additionalField,
  requiredField,
  collectSettingData,
  formatSettingData,
} from '../utils';

export default {
  type: 'resource',
  match(v) { return (v === 'resource') || (v.type === 'resource'); },
  fakeValue() { return ''; },
  save(hidden) {
    const data = collectSettingData('resource', hidden, 'required');
    return hidden.value = formatSettingData(data);
  },
  additionalFields(value, hidden) {
    const field = getNode(requiredField(hidden));
    additionalField('required', value, hidden, field, () => {
      this.save(hidden);
    });
    return [field];
  }
};
