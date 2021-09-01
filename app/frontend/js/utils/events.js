import {asPair} from 'widjet-utils';
import {DisposableEvent, Disposable, CompositeDisposable} from 'widjet-disposables';


const eachPair = (o, cb) => { asPair(o).forEach(([k,v]) => cb(k, v)); };
const NO_SELECTOR = '__NONE__';

export default class EventDelegate {

  constructor(object, selector, events) {
    this.subscribeTo(object, selector, events);
  }

  addDisposableEventListener(object, event, listener) {
    return new DisposableEvent(object, event, listener);
  }

  subscribeTo(object, selector, events) {
    if (!(object instanceof HTMLElement) && !(object instanceof HTMLDocument)) {
      [object, selector, events] = [this, object, selector];
    }
    if (typeof selector === 'object') {
      [events, selector] = [selector, NO_SELECTOR];
    }
    if (this.eventsMap == null) {
      this.eventsMap = new WeakMap();
    }
    if (this.disposablesMap == null) {
      this.disposablesMap = new WeakMap();
    }
    if (this.eventsMap.get(object) == null) {
      this.eventsMap.set(object, {});
    }
    if (this.disposablesMap.get(object) == null) {
      this.disposablesMap.set(object, {});
    }
    const eventsForObject = this.eventsMap.get(object);
    const disposablesForObject = this.disposablesMap.get(object);

    eachPair(events, (event, callback) => {
      if (eventsForObject[selector] == null) {
        eventsForObject[selector] = {};
        disposablesForObject[selector] = {};
      }
      disposablesForObject[selector][event] = this.createEventListener(object, event);
      eventsForObject[selector][event] = callback;
    });

    return new Disposable(() => {
      this.unsubscribeFrom(object, selector, events);
    });
  }

  unsubscribeFrom(object, selector, events) {
    if (!(object instanceof HTMLElement) && !(object instanceof HTMLDocument)) {
      [object, selector, events] = [this, object, selector];
    };
    if (typeof selector === 'object') {
      [events, selector] = [selector, NO_SELECTOR];
    }

    const eventsForObject = this.eventsMap.get(object);
    if (!eventsForObject) { return; }

    for (let event in events) {
      delete eventsForObject[event][selector];
      if (Object.keys(eventsForObject[event]).length === 0) {
        const disposablesForObject = this.disposablesMap.get(object);
        disposablesForObject[event].dispose();
        delete disposablesForObject[event];
        delete eventsForObject[event];
      }
    }
    if (Object.keys(eventsForObject).length === 0) {
      this.eventsMap.delete(object);
      return this.disposablesMap.delete(object);
    }
  }

  createEventListener(object, event) {
    const listener = (e) => {
      let target;

      const eventsForObject = this.eventsMap.get(object);
      if (!eventsForObject) { return; }

      ({target} = e);
      this.decorateEvent(e);
      this.eachSelectorFromTarget(e, target, eventsForObject);
      if (!e.isPropagationStopped) {
        if (typeof eventsForObject[NO_SELECTOR] === "function") {
          eventsForObject[NO_SELECTOR](e);
        }
      }
      return true;
    };
    return this.addDisposableEventListener(object, event, listener);
  }

  eachSelectorFromTarget(event, target, eventsForObject) {
    return this.nodeAndItsAncestors(target, (node) => {
      if (event.isPropagationStopped) {
        return;
      }
      return this.eachSelector(eventsForObject, event, (selector, callback) => {
        var matched;
        matched = this.targetMatch(node, selector);
        if (event.isImmediatePropagationStopped || !matched) {
          return;
        }
        return callback(event, matched);
      });
    });
  }

  eachSelector(eventsForObject, event, callback) {
    const keys = Object.keys(eventsForObject);

    if (keys.indexOf(NO_SELECTOR) !== -1) {
      keys.splice(keys.indexOf(NO_SELECTOR), 1);
    }

    keys.sort(function(a, b) {
      return b.split(' ').length - a.split(' ').length;
    });

    for (let i = 0, len = keys.length; i < len; i++) {
      const key = keys[i];
      if (callback(key, eventsForObject[key][event.type])) {
        return true;
      }
    }
    return false;
  }

  targetMatch(target, selector) {
    var parent;
    if (target.matches(selector)) {
      return target;
    }
    parent = target.parentNode;
    while ((parent != null) && (parent.matches != null)) {
      if (parent.matches(selector)) {
        return parent;
      }
      parent = parent.parentNode;
    }
    return null;
  }

  nodeAndItsAncestors(node, callback) {
    var parent, results;
    parent = node.parentNode;
    callback(node);
    results = [];
    while ((parent != null) && (parent.matches != null)) {
      callback(parent);
      results.push(parent = parent.parentNode);
    }
    return results;
  }

  decorateEvent(e) {
    const overriddenStop = Event.prototype.stopPropagation;
    const overriddenStopImmediate = Event.prototype.stopImmediatePropagation;
    const overriddenPrevent = Event.prototype.preventDefault;

    e.stopPropagation = function() {
      this.isPropagationStopped = true;
      overriddenStop.apply(this, arguments);
    };

    e.stopPropagation = function() {
      this.isPropagationStopped = true;
      overriddenStop.apply(this, arguments);
    };

    e.preventDefault = function() {
      this.isDefalutPrevented = true;
      overriddenPrevent.apply(this, arguments);
    };
  }

};
