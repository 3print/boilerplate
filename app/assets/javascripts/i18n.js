import {LOCALES} from './locales';

// Public
export default class I18n {
  static attachToWindow() {
    this.locale = document.querySelector('html').getAttribute('lang') || 'en';
    let instance = new I18n(LOCALES, this.locale);
    window.t = instance.getHelper();
    window.I18n = this;

    return String.prototype.t = function() { return window.t(this); };
  }

  /* Public */

  constructor(locales, defaultLanguage) {
    if (locales == null) { locales = {}; }
    this.locales = locales;
    if (defaultLanguage == null) { defaultLanguage = 'en'; }
    this.defaultLanguage = defaultLanguage;
    this.languages = ((() => {
      let result = [];
      for (let k in this.locales) {
        result.push(k);
      }
      return result;
    })()).sort();
  }

  // Returns a string from the locales.
  // That function can be called either with or without a language:
  //
  // i18n.get (path.to.string')
  // i18n.get ('fr', 'path.to.string')
  //
  // If the path lead to a dead end, the function return the last element
  // in the path as a capitalized sentence.
  //
  // i18n.get (path.that.do_not_exist) # Do Not Exist
  get(language, path, tokens) {
    if (tokens == null) { tokens = {}; }
    if ((path == null) || (typeof path === 'object')) {
      [language, path, tokens] = Array.from([this.defaultLanguage, language, path]);
    }

    let lang = this.locales[language];

    if (lang == null) { throw new Error(`Language ${language} not found`); }
    let els = path.split('.');
    for (let v of Array.from(els)) { lang = lang[v]; if (lang == null) { break; } }

    if ((typeof lang === 'object') && (tokens.count != null)) {
      lang = lang[tokens.count] != null ? lang[tokens.count] : lang.other;
    }

    if (lang == null) {
      lang = els.slice(-1)[0].replace(/[-_]/g, ' ')
                         .replace(/(^|\s)(\w)/g, (m,sp,s) => `${sp}${s.toUpperCase()}`);
    }

    return String(lang).replace(/\#\{([^\}]+)\}/g, function(token, key) {
      if (tokens[key] == null) { return token; }
      return tokens[key];
  });
  }

  // Returns a helper function bound to the current instance that allow
  // to retrieve localized string from the `I18n` instance as well as doing
  // token substitution in the returned string.
  //
  // ```coffee
  // _ = i18n.getHelper()
  // _('path.to.string')
  // _('path.to.string_with_token', token: 'token substitute')
  // ```
  getHelper() { return (path, tokens) => { if (tokens == null) { tokens = {}; } return this.get(path, tokens); }; }
};
