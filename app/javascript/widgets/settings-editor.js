import widgets from 'widjet';
import {asArray, parent, getNodes} from 'widjet-utils';
import SettingsEditor from './settings/editor';
import SettingsForm from './settings/form';

widgets.define('settings-editor', (options) => (el) => {
  el.editor = new SettingsEditor(el);
});

widgets.define('settings-form', (options) => (el) => {
  const form = el.form = new SettingsForm(el);
  const nodes = getNodes(form.render());

  asArray(el.querySelectorAll('[required="no"]')).forEach((input) => {
    parent(input, '.has-feedback').classList.remove('has-feedback');
    input.removeAttribute('required');
  });

  asArray(el.querySelectorAll('[multiple="no"]')).forEach((input) => {
    input.removeAttribute('multiple');
  });

  nodes.forEach(node => el.appendChild(node));

  requestAnimationFrame(() => widgets.dispatch(el, 'nested:fieldAdded'));
});
