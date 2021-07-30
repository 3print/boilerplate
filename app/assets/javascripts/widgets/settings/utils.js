import {asArray} from 'widjet-utils';
import {DisposableEvent} from 'widjet-disposables';

export const strip = (s) => s.replace(/^\s+|\s+$/g, '');
export const noEmptyString = (s) => strip(s) === '' ? undefined : s;
export const toArray = (s) => String(s).split(',').map(strip);

export const lightUnescape = (s) =>
  s
  .replace(/&lt;/g, '<')
  .replace(/&gt;/g, '>')
  .replace(/\\"/g, '"');

export const isBooleanField = (field) => {
  const type = field.getAttribute('type');
  return type === 'checkbox' || type === 'radio';
};

export const additionalField = (name, value, hidden, field, onUpdate) => {
  const f = field.querySelector(`[data-name="${name}"]`);
  hidden[`${name}_input`] = f;

  if (isBooleanField(f)) {
    if (value[name]) { f.setAttribute('checked', 'checked'); }
  } else {
    f.value = value[name];
  }

  return new DisposableEvent(f, 'change', onUpdate);
};

export const requiredField = (hidden) =>
  `\
<div class="form-group">
  <div class="controls">
    <label for="${hidden.id}_required">
      <input
        type="checkbox"
        class="form-check-input"
        id="${hidden.id}_required"
        data-name="required">
      </input>
      ${'settings_input.required.label'.t()}
    </label>
  </div>
</div>\
`;

export const collectSettingData = (type, hidden, ...fields) => {
  return asArray(fields).reduce((data, field) => {
    const input = hidden[`${field}_input`];
    if (isBooleanField(input)) {
      if(input.checked) { data[field] = input.checked; }
    } else {
      const value = noEmptyString(input.value);
      if (value != null) { data[field] = value; }
    }
    return data;
  }, {type});
};

export const formatSettingData = (data) => {
  if (Object.keys(data).length === 1) {
    return data.type;
  } else {
    return JSON.stringify(data);
  }
};
