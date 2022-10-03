window.addEventListener('DOMContentLoaded', (e) => {
  const consents = document.querySelector('.consents');
  const cookies = consents.querySelector('#cookies-consent');
  const configurePanel = consents.querySelector('#cookies-configure');

  let cookiesModal;
  if(cookies) {
    cookiesModal = Bootstrap.Modal.getOrCreateInstance(cookies);
    const configureButton = cookies.querySelector('.configure-cookies');
    if(configureButton) {
      configureButton.addEventListener('click', () => {
        switchToEditCookies();
        configurePanelModal.show();
      });
    }
  }

  const configurePanelModal = Bootstrap.Modal.getOrCreateInstance(configurePanel);
  const config = JSON.parse(consents.querySelector('script').textContent);
  const settingsOpeners = [].slice.call(document.querySelectorAll('.open-cookies-settings'));
  const scripts = {};
  let hasSetCookiesConsent = false;

  if(window.openCookies) {
    cookiesModal && cookiesModal.show();
  } else {
    hasSetCookiesConsent = true;
  }

  settingsOpeners.forEach((el) => {
    el.addEventListener('click', (e) => {
      e.preventDefault();
      openCookiesSettings();
    });
  });

  configurePanel.addEventListener('hide.bs.modal', () => {
    if(!hasSetCookiesConsent) {
      cookiesModal && cookiesModal.show();
    }
  });

  window.onAcceptAll = function onAcceptAll() {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, true);
      value.forEach((scr) => enableScript(scr, key));
    });
    hasSetCookiesConsent = true;
    cookiesModal && cookiesModal.hide();
    configurePanelModal.hide();
    switchToEditCookies();
  }

  window.onRejectAll = function onRejectAll() {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, false);
      disableScripts(key);
    });
    hasSetCookiesConsent = true;
    cookiesModal && cookiesModal.hide();
    configurePanelModal.hide();
    switchToEditCookies();
  }

  window.onConfigureCookies = function onConfigureCookies(setup) {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, setup[key]);
      setup[key]
        ? value.forEach((scr, i) => enableScript(scr, key, i))
        : disableScripts(key);
    });
    hasSetCookiesConsent = true;
    configurePanelModal.hide();
    switchToEditCookies();
  }

  window.openCookiesSettings = function openCookiesSettings() {
    cookiesModal && cookiesModal.hide();
    configurePanelModal.show();
  }

  function switchToEditCookies() {
    [].slice.call(document.querySelectorAll('.open-cookies-settings')).forEach(n => n.classList.add('visible'));
  }

  function enableScript(scr, group, index) {
    const id = `script-${group}-${index}`;

    if(!scripts[group] || !scripts[group].find(n => n.id == id)) {
      const script = document.createElement('script');
      script.id = id;
      if(scr.url) {
        script.src = scr.url;
      } else if(scr.inline) {
        script.innerText = scr.inline;
      }
      scripts[group] ||= [];
      scripts[group].push(script);
      document.head.appendChild(script);
    }
  }

  function disableScripts(name) {
    if(scripts[name] && scripts[name].length) {
      scripts[name].forEach(s => s.remove());
      config[name].forEach(scr => {
        scr.cookies.forEach(c => deleteCookie(c));
      });
      delete scripts[name];
    }
  }

  function toggleCheckbox(name, value) {
    configurePanel.querySelector(`.form-check-input[name="${name}"]`).checked = value;
  }

  function deleteCookie(name) {
    document.cookie = `${name}=;expires=Thu, 01 Jan 1970 00:00:01 GMT`;
  }
});
