import MegaMenu from '../classes/MegaMenu';

const headerClass = 'header';
const header = document.querySelector(`.${headerClass}`);
const megaMenus = {};
const { rootClass, triggerAttribute } = MegaMenu.getConfig();
const desktopMediaQuery = window.matchMedia('(min-width: 1024px)');
const mouseInTimeout = 100;
const mouseOutTimeout = 250;

let isDesktop = desktopMediaQuery.matches;
let openTimeout = null;
let closeTimeout = null;

Array.from(document.querySelectorAll(`.${rootClass}`))
  .forEach((element) => {
    megaMenus[element.id] = new MegaMenu(element);
  });

const megaMenusArray = Object.entries(megaMenus);

const closeAll = () => megaMenusArray.forEach(([, megaMenu]) => megaMenu.close());

const isAnyOpened = () => megaMenusArray.some(([, megaMenu]) => megaMenu.isOpened);

const overEventHandler = (event) => {
  // works only on desktop
  if (isDesktop) {
    // Check if pointed element is one of key elements
    const triggerElement = event.target.closest(`[${triggerAttribute}]`);
    const megaMenuElement = event.target.closest(`.${rootClass}`);

    // If any megamenu will be closed in some time
    // and is pointing on megamenu or trigger
    // prevent closing
    if (closeTimeout && (triggerElement || megaMenuElement)) {
      clearTimeout(closeTimeout);
      closeTimeout = null;
    }

    // If is pointing at trigger element
    if (triggerElement) {
      // Open mega menu in some time
      openTimeout = setTimeout(() => {
        const megaMenu = megaMenus[triggerElement.getAttribute(triggerAttribute)];
        event.stopPropagation();
        event.preventDefault();

        if (!megaMenu.isOpened) {
          openTimeout = null;
          closeAll();
          megaMenu.open();
        }
      }, mouseInTimeout);
    }
  }
};

const outEventHandler = (event) => {
  // Works only on desktop and if any megamenu is or will be opened
  if (isDesktop && (isAnyOpened() || openTimeout)) {
    // Prevent error if point to other window
    if (event.relatedTarget && event.relatedTarget.closest) {
      // Check if is pointing closest some key elements
      const closestMegaMenu = event.relatedTarget.closest(`.${rootClass}`);
      const closestTrigger = event.relatedTarget.closest(`[${triggerAttribute}]`);

      // if open megamenu will happen in some time
      // Prevent it
      if (openTimeout) {
        clearTimeout(openTimeout);
        openTimeout = null;
      }

      // If pointed element is not megamenu or trigger
      if (!closestMegaMenu && !closestTrigger && (closeTimeout == null)) {
        // Close every megamenu in some time
        closeTimeout = setTimeout(() => {
          closeTimeout = null;
          event.stopImmediatePropagation();
          closeAll();
        }, mouseOutTimeout);
      }
    }
  }
};

const keyUpEventhandler = ({ key }) => {
  if (key === 'Escape' && isAnyOpened()) {
    closeAll();
  }
};

const mediaQueryChangeEventHandler = (event) => {
  if (event.matches) {
    isDesktop = true;
  } else {
    isDesktop = false;
    closeAll();
  }
};

header.addEventListener('mouseover', overEventHandler);
header.addEventListener('mouseout', outEventHandler);
document.addEventListener('keyup', keyUpEventhandler);
desktopMediaQuery.addListener(mediaQueryChangeEventHandler);
