window.addEventListener('DOMContentLoaded', (e) => {
  const banner = document.querySelector('.consent-banner');
  const config = JSON.parse(banner.querySelector('script').textContent);
  const configureButton = banner.querySelector('.configure-cookies');
  const configurePanel = banner.querySelector('.configure-panel');
  const mainPanel = banner.querySelector('.main-panel');
  const settingsOpeners = [].slice.call(document.querySelectorAll('.open-cookies-settings'));
  const closeButton = configurePanel.querySelector('.btn-close');

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
      banner.querySelector(`.form-check-input[name="${key}"]`).checked = true;
      value.forEach((scr) => {
        const script = document.createElement('script');
        if(scr.url) {
          script.src = scr.url;
        } else if(scr.inline) {
          script.innerText = scr.inline;
        }
        document.head.appendChild(script);
      });
    });
    banner.classList.remove('visible');
    switchToEditCookies();
  }

  window.onRejectAll = function onRejectAll() {
    Object.entries(config).forEach(([key, value]) => {
      banner.querySelector(`.form-check-input[name="${key}"]`).checked = false;
    });
    banner.classList.remove('visible');
    switchToEditCookies();
  }

  window.onConfigureCookies = function onConfigureCookies(setup) {
    Object.entries(config).forEach(([key, value]) => {
      if(setup[key]) {
        banner.querySelector(`.form-check-input[name="${key}"]`).checked = true;
        value.forEach((scr) => {
          const script = document.createElement('script');
          if(scr.url) {
            script.src = scr.url;
          } else if(scr.inline) {
            script.innerText = scr.inline;
          }
          document.head.appendChild(script);
        });
      }
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
});
