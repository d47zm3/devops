const rootClass = 'js-gallery';
const sliderClass = 'js-gallery-slider';
const navSliderClass = 'js-gallery-nav-slider';
const thumbButtonClass = 'js-thumb-button';
const navButtonClass = 'js-nav-button';
const controlsClass = 'js-gallery-controls';
const dataIndex = 'data-index';
const dataIndexIncrement = 'data-index-increment';
const dataId = 'data-id';
const activeClass = 'active';
const loadingClass = 'gallery--loading';

const initSlider = (container, config = {}) => new window.Swiper(container, config);

const handleThumbNavClick = (button, slider) => {
  const imageId = button.getAttribute(dataId);

  if (imageId == null) {
    throw Error(`Navigation button should have '${dataId}' attribute`);
  }

  const slides = Array.from(slider.el.querySelectorAll('.swiper-slide'));
  const index = slides.findIndex(el => el.getAttribute(dataId) === imageId);

  slider.slideTo(index);
};

const handleNavButtonClick = (button, slider) => {
  const incrementBy = button.getAttribute(dataIndexIncrement);
  parseInt(incrementBy, 10) > 0
    ? slider.slideNext()
    : slider.slidePrev();
};

const handleNavigationClick = (slider) => (event) => {
  const { target } = event;
  const closestThumbButton = target.closest(`.${thumbButtonClass}`);
  const closestNavButton = target.closest(`.${navButtonClass}`);

  if (closestThumbButton != null) {
    event.preventDefault();
    handleThumbNavClick(closestThumbButton, slider);
  }

  if (closestNavButton != null) {
    event.preventDefault();
    handleNavButtonClick(closestNavButton, slider);
  }
};

// eslint-disable-next-line max-len
const testElementAttributeInt = (attributeName, testValue) => (element) => parseInt(element.getAttribute(attributeName), 10) === testValue;

const slideChangeHandler = (navs, thumbs, slider) => () => {
  const currentThumbButton = thumbs.find(testElementAttributeInt(dataIndex, slider.realIndex));
  const prevThumbButton = thumbs.find(testElementAttributeInt(dataIndex, slider.previousIndex));

  navs
    .find(el => el.getAttribute(dataIndexIncrement) === '-1')
    .disabled = slider.isBeginning;

  navs
    .find(el => el.getAttribute(dataIndexIncrement) === '1')
    .disabled = slider.isEnd;

  prevThumbButton && prevThumbButton.classList.remove(activeClass);
  currentThumbButton && currentThumbButton.classList.add(activeClass);
};

const initGallery = (gallery) => {
  const sliderContainer = gallery.querySelector(`.${sliderClass}`);
  const navSliderContainer = gallery.querySelector(`.${navSliderClass}`);

  let slider = {};
  let navSlider = {};

  if (sliderContainer != null) {
    slider = initSlider(sliderContainer);
    const navigation = gallery.querySelector(`.${controlsClass}`);
    const thumbButtons = Array.from(navigation.querySelectorAll(`.${thumbButtonClass}`));
    const navButtons = Array.from(navigation.querySelectorAll(`.${navButtonClass}`));

    navigation.addEventListener('click', handleNavigationClick(slider));

    slider.on('slideChange', slideChangeHandler(navButtons, thumbButtons, slider));
    slideChangeHandler(navButtons, thumbButtons, slider)();
  }

  if (navSliderContainer != null) {
    navSlider = initSlider(navSliderContainer, {
      spaceBetween: 8,
      slidesPerView: 'auto',
      slideToClickedSlide: true,
      freeMode: true,
      centeredSlides: true,
      threshold: 8,
    });
  }

  if (sliderContainer != null && navSliderContainer != null) {
    slider.controller.control = navSlider;
  }

  const io = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        window.setTimeout(() => {
          entry.target.classList.remove(loadingClass);
        }, 500);
        io.unobserve(entry.target);
      }
    });
  });

  io.observe(gallery);
};

export default (context) => {
  if (typeof window.Swiper === 'function') {
    const galleries = Array.from(context.querySelectorAll(`.${rootClass}`));
    galleries.forEach(initGallery);
  }
};
