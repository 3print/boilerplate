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
    console.log(object);
    if (!(object instanceof HTMLElement) && !(object instanceof HTMLDocument)) {
      [object, selector, events] = [this, object, selector];
    }
    console.log(object);
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
      if (eventsForObject[event] == null) {
        eventsForObject[event] = {};
        disposablesForObject[event] = this.createEventListener(object, event);
      }
      return eventsForObject[event][selector] = callback;
    });
    return new Disposable(() => {
      return this.unsubscribeFrom(object, selector, events);
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
      return this.eachSelector(eventsForObject, (selector, callback) => {
        var matched;
        matched = this.targetMatch(node, selector);
        if (event.isImmediatePropagationStopped || !matched) {
          return;
        }
        return callback(event);
      });
    });
  }

  eachSelector(eventsForObject, callback) {
    var i, key, keys, len;
    keys = Object.keys(eventsForObject);
    if (keys.indexOf(NO_SELECTOR) !== -1) {
      keys.splice(keys.indexOf(NO_SELECTOR), 1);
    }
    keys.sort(function(a, b) {
      return b.split(' ').length - a.split(' ').length;
    });
    for (i = 0, len = keys.length; i < len; i++) {
      key = keys[i];
      if (callback(key, eventsForObject[key])) {
        return true;
      }
    }
    return false;
  }

  targetMatch(target, selector) {
    var parent;
    if (target.matches(selector)) {
      return true;
    }
    parent = target.parentNode;
    while ((parent != null) && (parent.matches != null)) {
      if (parent.matches(selector)) {
        return true;
      }
      parent = parent.parentNode;
    }
    return false;
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
    var overriddenStop, overriddenStopImmediate;
    overriddenStop = Event.prototype.stopPropagation;
    e.stopPropagation = function() {
      this.isPropagationStopped = true;
      return overriddenStop.apply(this, arguments);
    };
    overriddenStopImmediate = Event.prototype.stopImmediatePropagation;
    return e.stopImmediatePropagation = function() {
      this.isImmediatePropagationStopped = true;
      return overriddenStopImmediate.apply(this, arguments);
    };
  }

};
