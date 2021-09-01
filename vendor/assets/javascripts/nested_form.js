import {parent, getNode, asArray} from 'widjet-utils';
import widgets from 'widjet';
import {DisposableEvent, CompositeDisposable} from 'widjet-disposables';
import EventDelegate from 'js/utils/events';

export default class NestedFormEvents {
  addFields(e, link) {
    e.preventDefault();

    // Setup
    const assoc = link.dataset.associationPath;

    const container = link.dataset.insertInto
      ? document.getElementById(link.dataset.insertInto)
      : parent(link);

    const blueprint = container.querySelector(`script`).textContent;
    const addedIndex = container.querySelectorAll(`.nested_${assoc}`).length;
    const indexPlaceholder = `__${assoc}_index__`;

    const content = blueprint.replace(new RegExp(indexPlaceholder, 'g'), addedIndex).replace(/^\s+|\s+$/gm, '');

    const field = this.insertFields(content, assoc, link, container);
    // bubble up event upto document (through form)
    widgets.dispatch(field, 'nested:fieldAdded', {field});
    widgets.dispatch(field, `nested:fieldAdded:${assoc}`, {field});
    return false;
  }
  newId() {
    return new Date().getTime();
  }
  insertFields(content, assoc, link, container) {
    const node = getNode(content, container.nodeName);

    if (content.indexOf('<tr') !== -1) {
      const tr = parent(link, 'tr');
      tr.parentNode.insertBefore(node, tr);
    } else if (content.indexOf('<li') !== -1) {
      const li = parent(link, 'li');
      li.parentNode.insertBefore(node, li);
    } else {
      const target = link.dataset.target;
      if (target) {
        target.appendChild(node);
      } else {
        link.parentNode.insertBefore(node, link);
      }
    }
    return node;
  }
  removeFields(e, link) {
    e.preventDefault();

    const objectClass = link.dataset.objectClass;
    const deleteAssociationFieldName = link.dataset.deleteAssociationFieldName;
    const removedIndex = parseInt(deleteAssociationFieldName.match('(\\d+\\]\\[_destroy])')[0].match('\\d+')[0]);

    const field = parent(link, '.nested_fields');
    const deleteField = field.querySelector(`input[type='hidden'][name='${deleteAssociationFieldName}']`);

    if (deleteField != null) {
      deleteField.value = '1';
    } else {
      const node = getNode(`<input type='hidden' name='${deleteAssociationFieldName}' value='1' />`);
      field.parentNode.insertBefore(node, field);
    }

    field.style.display = 'none';
    asArray(field.querySelectorAll('input[required], select[required], textarea[required]')).forEach((n) => {
      n.removeAttribute('required');
    });

    widgets.dispatch(field, 'nested:fieldRemoved', {field});
    return false;
  }
}

window.nestedFormEvents = new NestedFormEvents();
const delegates = [
  new EventDelegate(document, 'form a.add_nested_fields_link', {
    'click': (e, el) => nestedFormEvents.addFields(e, el),
  }),
  new EventDelegate(document, 'form a.remove_nested_fields_link', {
    'click': (e, el) => nestedFormEvents.removeFields(e, el),
  }),
];
