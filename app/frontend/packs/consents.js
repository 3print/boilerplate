window.addEventListener('DOMContentLoaded', (e) => {
  const banner = document.querySelector('.consent-banner');
  const config = JSON.parse(banner.querySelector('script').textContent);
  const configureButton = banner.querySelector('.configure-cookies');
  const configurePanel = banner.querySelector('.configure-panel');
  const mainPanel = banner.querySelector('.main-panel');

  configureButton.addEventListener('click', (e) => {
    mainPanel.classList.remove('visible');
    configurePanel.classList.add('visible');
  })

  window.onAcceptAll = function onAcceptAll() {
    Object.entries(config).forEach(([key, value]) => {
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
    banner.remove();
  }

  window.onRejectAll = function onRejectAll() {
    banner.remove();
  }

  window.onConfigureCookies = function onConfigureCookies(setup) {
    Object.entries(config).forEach(([key, value]) => {
      if(setup[key]) {
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
    banner.remove();
  }
});
