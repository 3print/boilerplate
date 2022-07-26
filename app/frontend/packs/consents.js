window.addEventListener('DOMContentLoaded', (e) => {
  const banner = document.querySelector('.consent-banner');
  const config = JSON.parse(banner.querySelector('script').textContent);
  const configureButton = banner.querySelector('.configure-cookies');
  const configurePanel = banner.querySelector('.configure-panel');
  const mainPanel = banner.querySelector('.main-panel');
  const settingsOpeners = [].slice.call(document.querySelectorAll('.open-cookies-settings'));
  const closeButton = configurePanel.querySelector('.btn-close');
  const scripts = {};

  settingsOpeners.forEach((el) => {
    el.addEventListener('click', (e) => {
      e.preventDefault();
      openCookiesSettings();
    });
  });

  if(configureButton) {
    configureButton.addEventListener('click', switchToEditCookies);
  }

  closeButton.addEventListener('click', () => {
    banner.classList.remove('visible');
  });

  window.onAcceptAll = function onAcceptAll() {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, true);
      value.forEach((scr) => enableScript(scr, key));
    });
    banner.classList.remove('visible');
    switchToEditCookies();
  }

  window.onRejectAll = function onRejectAll() {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, false);
      disableScripts(key);
    });
    banner.classList.remove('visible');
    switchToEditCookies();
  }

  window.onConfigureCookies = function onConfigureCookies(setup) {
    Object.entries(config).forEach(([key, value]) => {
      toggleCheckbox(key, setup[key]);
      setup[key]
        ? value.forEach((scr, i) => enableScript(scr, key, i))
        : disableScripts(key);
    });
    banner.classList.remove('visible');
    switchToEditCookies();
  }

  window.openCookiesSettings = function openCookiesSettings() {
    banner.classList.add('visible');
    configurePanel.classList.add('visible');
    closeButton.classList.add('visible');
  }

  function switchToEditCookies() {
    mainPanel && mainPanel.classList.remove('visible');
    configurePanel.classList.add('visible');
  }

  function enableScript(scr, group, index) {
    const id = `script-${group}-${index}`;

    console.log(`enable ${scr}, ${group}: ${!scripts[group] || !scripts[group].find(n => n.id == id)}`);

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
    console.log(`disable ${name}: ${scripts[name] && scripts[name].length}`);
    if(scripts[name] && scripts[name].length) {
      scripts[name].forEach(s => s.remove());
      config[name].forEach(scr => {
        scr.cookies.forEach(c => deleteCookie(c));
      });
      delete scripts[name];
    }
  }

  function toggleCheckbox(name, value) {
    banner.querySelector(`.form-check-input[name="${name}"]`).checked = value;
  }

  function deleteCookie(name) {
    console.log(`delete cookie ${name}`);
    document.cookie = `${name}=;expires=Thu, 01 Jan 1970 00:00:01 GMT`;
  }
});
