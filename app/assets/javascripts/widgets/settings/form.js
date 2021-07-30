import {isJSON} from 'widjet-json-form/lib/utils';

let nextID = 0;

const getNextD = () => nextID++;

const flatReducer = (acc, v) => acc.concat(Array.isArray(v) ? flatten(v) : v);

const flatten = a => a.reduce(flatReducer, []);

const split = s => flatten(s.split('{{').map(s => s.split('}}')));

const mapParts = s => {
  let m;
  if ((m = /^\s*=/.exec(s))) {
    return s.slice(m[0].length);
  } else {
    return `'${s.replace(/'/g, "\\'")}'`;
  }
};

const exprReducer = (acc, s) => {
  if ((acc.length > 0) && acc[acc.length - 1].match(/(\?|:)\s*$/)) {
    acc[acc.length - 1] += s;
  } else if (s.match(/^\s*(:|\))\s*$/)) {
    acc[acc.length - 1] += s;
  } else if (!s.match(/^\s*'|\?\s*$/)) {
    acc.push(`(${s})`);
  } else {
    acc.push(s);
  }

  return acc;
};

const sanitize = str =>
  str
  .replace(/\s+/g, ' ')
  .replace(/&gt;/g, '>')
  .replace(/&lt;/g, '<')
  .replace(/&amp;/g, '&')
;

const convert = str =>
  split(sanitize(str)).map(mapParts).reduce(exprReducer, []).join(' + ');

export default class SettingsForm {
  static tpl(str, data) {
    if (this.tplCache == null) { this.tplCache = {}; }
    // Figure out if we're getting a template, or if we need to
    // load the template - and be sure to cache the result.
    let fn = /^[-_a-zA-Z]+$/.test(str)
      ? this.tplCache[str] != null
        ? this.tplCache[str]
        : (this.tplCache[str] = this.tpl(document.getElementById(str).innerHTML))
      :
        (() => {
          let body;
          try {
            body = `with(obj){ return ${convert(str)} }`;
            return new Function('obj', body);
          } catch (e) {
            console.error(str);
            console.error(body);
            throw e;
          }
        })();
    // Provide some basic currying to the user
    if (data) { return fn(data); } else { return fn; }
  }

  constructor(source) {
    this.source = source;
    this.settings = JSON.parse(this.source.dataset.settings);
    this.values = this.source.dataset.values
      ? JSON.parse(this.source.dataset.values)
      : {};
    this.id = this.source.dataset.id
      ? this.source.dataset.id
      : getNextD();
  }

  render() {
    return Object.keys(this.settings).reduce((html, setting) => {
      let type = this.settings[setting];
      html += "<div class='field'>";

      const label = `settings_form.${setting}`.t();
      const id = `${setting}-${this.id}`;
      let settingParameters = {};

      if ((typeof type === 'string') && isJSON(type)) {
        type = JSON.parse(type);
      }

      if ((type != null) && (typeof type === 'object')) {
        settingParameters = type;
        ({type} = type);
      }

      html += this.getField(type, {
        id,
        label,
        setting,
        settingParameters,
        value: this.values[setting]
      });

      html += '</div>';
      return html;
    }, '');
  }

  getField(type, options) {
    const tpl = typeof JST != 'undefined'
      ? JST[`templates/settings/${type}`]
      : this.constructor.tpl(type)
    return tpl(options);
  }
};
