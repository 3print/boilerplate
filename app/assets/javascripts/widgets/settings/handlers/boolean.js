SettingsEditor.handlers.push({
  type: 'boolean',
  save(hidden) { return hidden.value = 'boolean'; },
  match(v) { return (v === 'boolean') || (v.type === 'boolean'); },
  fake_value() { return Math.random() > 0.5; }
});
