const rootClass = 'js-accordion';
const animatingClass = 'accordion--animating';
const openedClass = 'accordion--opened';
const contentClass = 'js-accordion-content';
const dataTrigger = 'data-accordion-trigger';
const dataGroup = 'data-accordion-group';

const accordions = Array.from(document.querySelectorAll(`.${rootClass}`));

const initAccordion = (accordion) => {
  const contentElement = accordion.querySelector(`.${contentClass}`);

  let isOpened = false;
  let isAnimating = false;

  const getHeight = (element) => element.clientHeight;

  const getGroup = (element) => element.getAttribute(dataGroup);

  const getId = (element) => element.getAttribute('id');

  const transitionEndHandler = () => {
    if (isAnimating) {
      isAnimating = false;
      isOpened = !isOpened;
      accordion.classList.remove(animatingClass);

      if (isOpened) {
        accordion.classList.add(openedClass);
      }
    }
  };

  const open = () => {
    if (!isOpened) {
      isAnimating = true;
      accordion.removeAttribute('hidden');
      accordion.classList.add(animatingClass);
      accordion.style.maxHeight = `${getHeight(contentElement)}px`;
    }
  };

  const close = () => {
    if (isOpened) {
      isAnimating = true;
      accordion.setAttribute('hidden', '');
      accordion.classList.add(animatingClass);
      accordion.classList.remove(openedClass);
      accordion.style.maxHeight = '0px';
    }
  };

  const toggle = () => {
    isOpened
      ? close()
      : open();
  };

  accordion.addEventListener('transitionend', transitionEndHandler);

  return {
    id: getId(accordion),
    groupName: getGroup(accordion),
    open,
    close,
    toggle,
  };
};

const accordionInstances = accordions.map(initAccordion);

const bodyClickHandler = (event) => {
  if (event.target != null) {
    const clickTarget = event.target.closest(`[${dataTrigger}]`);

    if (clickTarget != null) {
      const accordion = accordionInstances
        .find((instance) => instance.id === clickTarget.getAttribute(dataTrigger));

      if (accordion != null) {
        event.preventDefault();
        accordion.toggle();

        if (accordion.groupName) {
          accordionInstances
            .filter((element) => element.groupName === accordion.groupName && element.id !== accordion.id)
            .forEach((element) => element.close());
        }
      }
    }
  }
};

document.body.addEventListener('click', bodyClickHandler);
