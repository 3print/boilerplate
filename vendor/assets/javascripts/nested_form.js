import {parent, getNode} from 'widjet-utils';
import widgets from 'widjet';

export default class NestedFormEvents {
  addFields(e) {
    // Setup
    const link      = e.currentTarget;
    const assoc     = link.dataset.association;
    const blueprint = document.querySelector(`#${link.dataset['blueprint-id']}`);
    let content   = blueprint.dataset.blueprint;

    // Make the context correct by replacing <parents> with the generated ID
    // of each of the parent objects
    const context = (parent(link, '.fields').querySelector('input, textarea, select').getAttribute('name') || '').replace(new RegExp('\[[a-z_]+\]$'), '');

    // context will be something like this for a brand new form:
    // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
    // or for an edit form:
    // project[tasks_attributes][0][assignments_attributes][1]
    if (context !== '') {
      const parentNames = context.match(/[a-z_]+_attributes(?=\]\[(new_)?\d+\])/g) || [];
      const parentIds   = context.match(/[0-9]+/g) || [];

      for(let i = 0; i < parentNames.length; i++) {
        if(parentIds[i]) {
          content = content.replace(
            new RegExp('(_' + parentNames[i] + ')_.+?_', 'g'),
            '$1_' + parentIds[i] + '_');

          content = content.replace(
            new RegExp('(\\[' + parentNames[i] + '\\])\\[.+?\\]', 'g'),
            '$1[' + parentIds[i] + ']');
        }
      }
    }

    // Make a unique ID for the new child
    const regexp = new RegExp('new_' + assoc, 'g');
    const new_id = this.newId();

    content = content.replace(regexp, new_id).replace(/^\s+|\s+$/gm, '');

    const field = this.insertFields(content, assoc, link);
    // bubble up event upto document (through form)
    field
      .trigger({ type: 'nested:fieldAdded', field: field })
      .trigger({ type: 'nested:fieldAdded:' + assoc, field: field });
    return false;
  }
  newId() {
    return new Date().getTime();
  }
  insertFields(content, assoc, link) {
    const node = getNode(content);
    if (content.indexOf('<tr') !== -1) {
      const tr = parent(link, 'tr');
      return tr.parentNode.insertBefore(node, tr);
    } else if (content.indexOf('<li') !== -1) {
      const li = parent(link, 'li');
      return li.parentNode.insertBefore(node, li);
    } else {
      const target = link.dataset.target;
      if (target) {
        return target.appendChild(node);
      } else {
        return link.parentNode.insertBefore(node, link);
      }
    }
  }
  removeFields(e) {
    const link = e.currentTarget;
    const assoc = link.dataset.association; // Name of child to be removed

    const field = parent(link,'.fields');
    const hiddenField = field.querySelector('input[type=hidden]');

    hiddenField.value = '1';
    field.style.display = 'none';

    widgets.dispatch(field, 'nested:fieldRemoved', {field});
    widgets.dispatch(field, `nested:fieldRemoved:${assoc}`, {field});
    return false;
  }
}

window.nestedFormEvents = new NestedFormEvents();
$(document)
  .delegate('form a.add_nested_fields',    'click', nestedFormEvents.addFields)
  .delegate('form a.remove_nested_fields', 'click', nestedFormEvents.removeFields);
