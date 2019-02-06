import { getImageSlide, getTextSlide } from '../views/lightbox';

const rootClass = 'js-lightbox';
const autoFillClass = 'js-lightbox-auto';
const imageSliderClass = 'js-lightbox-slider-image';
const textSliderClass = 'js-lightbox-slider-text';
const prevSliderClass = 'js-lightbox-slider-prev';
const nextSliderClass = 'js-lightbox-slider-next';
const textToggleClass = 'js-lightbox-text-toggle';
const closeClass = 'js-lightbox-close';
const textContainerClass = 'lightbox__container--text';
const triggerAttribute = 'data-lightbox-trigger';
const visibleClass = 'visible';

const dataContext = 'data-lightbox';
const dataAuthor = 'data-author';
const dataFullImage = 'data-full';
const dataText = 'data-text';
const dataId = 'data-id';
const dataShareHref = 'data-share-href';
const dataShareDescription = 'data-share-description';
const dataShareTitle = 'data-share-title';


const getCloseTriggers = (contextElement, cls) => Array.from(contextElement.querySelectorAll(`.${cls}`));

const getSlider = (container, config = {}) => {
  const defaultConfig = {
    observer: true,
    observeParents: true,
    roundLengths: true,
  };

  return new window.Swiper(container, Object.assign({}, defaultConfig, config));
};

const updateDomControls = (slider, domElements) => {
  domElements.prevSliderControl.disabled = slider.isBeginning;
  domElements.nextSliderControl.disabled = slider.isEnd;
};

const prevSlideEventHandler = (imageSlider, domElements) => () => {
  imageSlider.slidePrev();
  updateDomControls(imageSlider, domElements);
};

const nextSlideEventHandler = (imageSlider, domElements) => () => {
  imageSlider.slideNext();
  updateDomControls(imageSlider, domElements);
};

const gotoSlideEventHandler = (imageSlider, domElements) => (index) => {
  setTimeout(() => {
    imageSlider.slideTo(index);
    updateDomControls(imageSlider, domElements);
  }, 50);
};

const keyupHandler = (lightbox, event) => {
  if (event.key === 'Escape' || event.which === 27) {
    lightbox.close();
  }

  if (lightbox.slider != null) {
    if (event.key === 'ArrowLeft' || event.which === 37) {
      lightbox.slider.prev();
    }

    if (event.key === 'ArrowRight' || event.which === 39) {
      lightbox.slider.next();
    }
  }
};

const initSlider = (context) => {
  if (typeof window.Swiper === 'function') {
    const imageSliderContainer = context.querySelector(`.${imageSliderClass}`);
    const textSliderContainer = context.querySelector(`.${textSliderClass}`);
    const prevSliderControl = context.querySelector(`.${prevSliderClass}`);
    const nextSliderControl = context.querySelector(`.${nextSliderClass}`);
    let imageSlider = {};
    let textSlider = {};

    if (imageSliderContainer != null && textSliderContainer != null) {
      imageSlider = getSlider(imageSliderContainer, {
        spaceBetween: 16,
      });

      textSlider = getSlider(textSliderContainer, {
        spaceBetween: 16,
      });


      const handlerData = [
        imageSlider,
        {
          prevSliderControl,
          nextSliderControl,
        },
      ];

      imageSlider.on('slideChange', () => updateDomControls(...handlerData));
      prevSliderControl.addEventListener('click', prevSlideEventHandler(...handlerData));
      nextSliderControl.addEventListener('click', nextSlideEventHandler(...handlerData));
      updateDomControls(...handlerData);

      imageSlider.controller.control = textSlider;
      textSlider.controller.control = imageSlider;

      return {
        imageSlider,
        textSlider,
        next: nextSlideEventHandler(...handlerData),
        prev: prevSlideEventHandler(...handlerData),
        goto: gotoSlideEventHandler(...handlerData),
      };
    }

    return null;
  }

  return null;
};

const getContext = (lightbox) => lightbox.closest(`[${dataContext}]`);

const getDataFromTrigger = (trigger, position, len) => ({
  currentSlide: position,
  slidesCount: len,
  author: trigger.getAttribute(dataAuthor),
  fullImage: trigger.getAttribute(dataFullImage),
  text: trigger.getAttribute(dataText),
  id: trigger.getAttribute(dataId),
  shareDescription: trigger.getAttribute(dataShareDescription),
  shareHref: trigger.getAttribute(dataShareHref),
  shareTitle: trigger.getAttribute(dataShareTitle),
});

const getTextSlideFromTriggerData = (triggerData) => getTextSlide(triggerData);

const getImageSlideFromTriggerData = (triggerData) => getImageSlide(triggerData.fullImage, triggerData.id);

const getSlidesFromTriggerData = (triggerData) => ({
  text: getTextSlideFromTriggerData(triggerData),
  image: getImageSlideFromTriggerData(triggerData),
});

const fillLightbox = (lightbox, slides) => {
  const sliderTextContent = lightbox.querySelector(`.${textSliderClass} .swiper-wrapper`);
  const sliderImageContent = lightbox.querySelector(`.${imageSliderClass} .swiper-wrapper`);

  sliderTextContent.innerHTML = slides.map(el => el.text).join('\n');
  sliderImageContent.innerHTML = slides.map(el => el.image).join('\n');
};

const initWithAutofill = (lightbox) => {
  const context = getContext(lightbox);
  const contextUuid = context.getAttribute(dataContext);
  const triggers = Array.from(context.querySelectorAll(`[${triggerAttribute}="${contextUuid}"]`));
  const slides = triggers.map((trigger, index, arr) => getSlidesFromTriggerData(getDataFromTrigger(trigger, index + 1, arr.length)));
  fillLightbox(lightbox, slides);
};

const initLightbox = (lightbox) => {
  let opened = false;
  const autofill = lightbox.classList.contains(autoFillClass);

  const textContainer = lightbox.querySelector(`.${textContainerClass}`);

  const isOpened = () => opened;

  const isAutofill = () => autofill;

  const close = () => {
    lightbox.hidden = true;
    document.body.classList.remove('lightbox-opened');
    opened = false;
  };

  const open = () => {
    lightbox.hidden = false;
    document.body.classList.add('lightbox-opened');
    opened = true;
  };

  const toggle = () => {
    opened
      ? close()
      : open();
  };

  const toggleText = () => {
    textContainer.classList.toggle(visibleClass);
  };

  const closeTriggers = getCloseTriggers(lightbox, closeClass);

  closeTriggers.forEach((trigger) => {
    trigger.addEventListener('click', (event) => {
      event.preventDefault();
      close();
    });
  });

  if (isAutofill()) initWithAutofill(lightbox);

  const slider = initSlider(lightbox);

  return {
    id: lightbox.getAttribute(dataId),
    open,
    close,
    toggle,
    isOpened,
    slider,
    toggleText,
  };
};

const bodyClickHandler = (lightboxInstances) => (event) => {
  if (event.target != null) {
    const clickTarget = event.target.closest(`[${triggerAttribute}]`);
    const closestTextToggle = event.target.closest(`.${textToggleClass}`);
    const openedInstances = lightboxInstances.filter((instance) => instance.isOpened());

    if (clickTarget != null) {
      const lightbox = lightboxInstances
        .find((instance) => instance.id === clickTarget.getAttribute(triggerAttribute));

      if (lightbox != null) {
        const targetId = clickTarget.getAttribute(dataId);
        const slides = Array.from(lightbox.slider.imageSlider.el.querySelectorAll('.swiper-slide'));
        const index = slides.findIndex(el => el.getAttribute(dataId) === targetId);

        event.preventDefault();
        lightbox.open();

        if (index != null && lightbox.slider != null) {
          lightbox.slider.goto(index);
        }
      }
    }

    if (closestTextToggle != null) {
      openedInstances.forEach((instance) => {
        instance.toggleText();
      });
    }
  }
};

const bodyKeyupHandler = (lightboxInstances) => (event) => {
  const openedLightboxes = lightboxInstances.filter((lightbox) => lightbox.isOpened());

  if (openedLightboxes.length > 0) {
    event.preventDefault();
    openedLightboxes.forEach((lightbox) => keyupHandler(lightbox, event));
  }
};

export default (context) => {
  const lightboxes = Array.from(context.querySelectorAll(`.${rootClass}`));
  const lightboxInstances = lightboxes.map(initLightbox);

  document.body.addEventListener('click', bodyClickHandler(lightboxInstances));
  document.body.addEventListener('keyup', bodyKeyupHandler(lightboxInstances));
};
