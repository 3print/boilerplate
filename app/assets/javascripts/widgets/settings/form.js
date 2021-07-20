let {is_json} = SettingsEditor.Utils;

let next_id = 0;

let get_next_id = () => next_id++;

let flat_reducer = (acc, v) => acc.concat(Array.isArray(v) ? flatten(v) : v);

var flatten = a => a.reduce(flat_reducer, []);

let split = s => flatten(s.split('{{').map(s => s.split('}}')));

let map_parts = function(s) {
  let m;
  if ((m = /^\s*=/.exec(s))) {
    return s.slice(m[0].length);
  } else {
    return `'${s.replace(/'/g, "\\'")}'`;
  }
};

let expr_reducer = function(acc, s) {
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

let sanitize = str =>
  str
  .replace(/\s+/g, ' ')
  .replace(/&gt;/g, '>')
  .replace(/&lt;/g, '<')
  .replace(/&amp;/g, '&')
;

let convert = str => split(sanitize(str)).map(map_parts).reduce(expr_reducer, []).join(' + ');

window.SettingsForm = class SettingsForm {
  static tpl(str, data) {
    if (this.tpl_cache == null) { this.tpl_cache = {}; }
    // Figure out if we're getting a template, or if we need to
    // load the template - and be sure to cache the result.
    let fn = /^[-_a-zA-Z]+$/.test(str) ?
      this.tpl_cache[str] != null ? this.tpl_cache[str] : (this.tpl_cache[str] = this.tpl(document.getElementById(str).innerHTML))
    :
      (() => { let body;
      try {
        body = `with(obj){ return ${convert(str)} }`;
        return new Function('obj', body);
      } catch (e) {
        console.error(str);
        console.error(body);
        throw e;
      } })();
    // Provide some basic currying to the user
    if (data) { return fn(data); } else { return fn; }
  }

  constructor(source) {
    let left, left1;
    this.source = source;
    this.settings = this.source.data('settings');
    this.values = (left = this.source.data('values')) != null ? left : {};
    this.id = (left1 = this.source.data('id')) != null ? left1 : get_next_id();
  }

  render() {
    let html = '';

    for (let setting in this.settings) {
      let type = this.settings[setting];
      html += "<div class='field'>";

      let label = `settings_form.${setting}`.t();
      let id = `${setting}-${this.id}`;
      let setting_parameters = {};

      if ((typeof type === 'string') && is_json(type)) { type = JSON.parse(type); }

      if ((type != null) && (typeof type === 'object')) {
        setting_parameters = type;
        ({type} = type);
      }

      html += this.get_field(type, {
        id,
        label,
        setting,
        setting_parameters,
        value: this.values[setting]
      });

      html += '</div>';
    }

    return html;
  }

  get_field(type, options) {
    let tpl = JST[`templates/settings/${type}`] != null ? JST[`templates/settings/${type}`] : this.constructor.tpl(type);
    return tpl(options);
  }
};
