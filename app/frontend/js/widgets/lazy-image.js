import widgets from 'widjet';

const getScrollTop = () =>
  document.body.scrollTop
  || document.documentElement.scrollTop
  || window.scrollTop
  || 0;

const parsesJSON = (str, def) => {
  try {
    return JSON.parse(str) || def;
  } catch (e) {
    console.warn('Unable to parse JSON', str, e.stack);
    return def;
  }
}

widgets.define('lazy-image', (options = {}) => {
  const overflowThreshold =  options.overflowThreshold || 500;
  const useDistance = options.useDistance != undefined
    ? options.useDistance
    : false;

  let frameRequested, pendingImages = [];

  window.addEventListener('scroll', requestFrame);
  document.body.addEventListener('scroll', requestFrame);
  document.documentElement.addEventListener('scroll', requestFrame);

  return img => {
    const config = parsesJSON(img.getAttribute('data-lazy'), {});
    const scrollTop = getScrollTop();

    if (!imageLoaded(img) && (config.src || config.srcset)) {
      console.log("register lazy image", img, config);
      pendingImages.push([img, config]);
    }

    requestFrame();
  }

  function handleScroll() {
    const scrollTop = getScrollTop();

    const min = scrollTop - overflowThreshold;
    const max = scrollTop + window.innerHeight + overflowThreshold;

    pendingImages = pendingImages.filter(([img, config]) => {
      const {src, srcset, usepicture} = config;
      const bounds = img.getBoundingClientRect();
      const top = bounds.top + scrollTop;
      const bottom = bounds.bottom + scrollTop;

      if (!isVisible(img)) { return true; }

      let handled = false;
      if ((top <= max && bottom >= min) || (top  < min && bottom > max)) {
        if (usepicture) {
          console.log('creating picture for', img);

          const picture = document.createElement('picture');

          const html = `${
            srcsets.map(({url, media}) => `<source srcset="${url}" media="${media}"/>`).join('\n')
          }
          <img src="${config.src}" alt="${img.alt}" class="${img.className}" data-lazy-loaded>`;

          picture.innerHTML = html;
          const newImg = picture.querySelector('img');
          img.onload = () => widgets.dispatch('lazy-image:loaded');

          img.parentNode.insertBefore(picture, img);
          img.parentNode.removeChild(img);
          handled = true;
        } else {
          console.log('setting src for', img);
          img.src = config.src;
          img.onload = () => widgets.dispatch('lazy-image:loaded');
          img.setAttribute('data-lazy-loaded', 'data-lazy-loaded');
          handled = true;
        }
      }

      return !handled;
    })
  }

  function requestFrame() {
    if (frameRequested) { return }
    requestAnimationFrame(() => {
      handleScroll();
      frameRequested = false;
    })
    frameRequested = true;
  }

  function imageLoaded(el) {
    return el.hasAttribute('data-lazy-loaded');
  }

  function isVisible (node) {
    return node.offsetWidth !== 0 && node.offsetHeight !== 0;
  }
})
