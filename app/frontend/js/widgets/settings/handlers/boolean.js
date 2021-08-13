export default {
  type: 'boolean',
  save(hidden) { return hidden.value = 'boolean'; },
  match(v) { return v === 'boolean' || v.type === 'boolean'; },
  fakeValue() { return Math.random() > 0.5; }
}
