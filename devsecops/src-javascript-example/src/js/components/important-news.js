if (typeof window.Swiper === 'function') {
  const importantNewsContainer = '.important-news';
  const initSlider = (container, config = {}) => new window.Swiper(container, config);

  initSlider(importantNewsContainer, {
    autoplay: {
      delay: 7000,
    },
    pagination: {
      el: '.swiper-pagination',
      type: 'fraction',
    },
    loop: true,
    effect: 'slide',
    speed: 2000,
  });
}
