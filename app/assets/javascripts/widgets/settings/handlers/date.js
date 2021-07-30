import {getNode} from 'widjet-utils';
import {
  additionalField,
  collectSettingData,
  formatSettingData,
  requiredField,
} from '../utils';

export default (type) => {
  return {
    type,
    match(v) { return (v === type) || (v.type === type); },
    fakeValue() { return new Date(); },
    save(hidden) {
      const data = collectSettingData(type, hidden, 'required');
      hidden.value = formatSettingData(data);
    },

    additionalFields(value, hidden) {
      let field = getNode(requiredField(hidden));
      additionalField('required', value, hidden, field, () => {
        this.save(hidden);
      });
      return [field];
    }
  };
};
