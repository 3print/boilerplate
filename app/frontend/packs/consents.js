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
      value.forEach((src) => {
        const script = document.createElement('script');
        script.src = src;
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
        value.forEach((src) => {
          const script = document.createElement('script');
          script.src = src;
          document.head.appendChild(script);
        });
      }
    });
    banner.remove();
  }
});
