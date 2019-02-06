const rootClass = 'side-nav';
const openedClass = `${rootClass}--opened`;
const triggerClass = 'js-side-nav-trigger';

const listRootClass = 'navlist';
const linkClass = `${listRootClass}__link`;
const activeLinkClass = `${linkClass}--active`;
const expandableLinkClass = `${linkClass}--hasSub`;
const subListClass = `${listRootClass}__sub`;
const subListOpenedClass = `${listRootClass}--opened`;

const rootElement = document.querySelector(`.${rootClass}`);

if (rootElement) {
  let isOpened = false;
  const subListElements = Array.from(rootElement.querySelectorAll(`.${subListClass}`));

  const open = () => {
    rootElement.classList.add(openedClass);
    isOpened = true;
  };

  const close = () => {
    rootElement.classList.remove(openedClass);
    isOpened = false;
  };

  const toggle = () => {
    isOpened
      ? close()
      : open();
  };

  const closeSubList = (subList) => {
    const toggleElement = subList.previousElementSibling;

    toggleElement.classList.remove(activeLinkClass);
    subList.classList.remove(subListOpenedClass);
    subList.style.maxHeight = null; // eslint-disable-line no-param-reassign
  };

  const openSubList = (subList) => {
    const listElements = Array.from(subList.children);
    const toggleElement = subList.previousElementSibling;
    const openedHeight = listElements.reduce((accumulator, current) => accumulator + current.clientHeight, 0);

    subListElements.forEach(closeSubList);

    toggleElement.classList.add(activeLinkClass);
    subList.classList.add(subListOpenedClass);
    subList.style.maxHeight = `${openedHeight}px`; // eslint-disable-line no-param-reassign
  };

  const onExpandableClick = (element) => {
    const subList = element.nextElementSibling;

    if (subList) {
      subList.classList.contains(subListOpenedClass)
        ? closeSubList(subList)
        : openSubList(subList);
    }
  };

  rootElement.addEventListener('click', (event) => {
    const isExpandableLink = event.target.classList.contains(expandableLinkClass);

    if (isExpandableLink) {
      event.preventDefault();
      onExpandableClick(event.target);
    }
  });

  document.addEventListener('keyup', ({ key }) => {
    if (key === 'Escape' && isOpened) {
      close();
    }
  });

  document.addEventListener('click', (event) => {
    const isTriggerElement = event.target.classList.contains(triggerClass);
    const isOuterClick = isOpened && !event.target.closest(`.${rootClass}`);

    if (isTriggerElement) {
      event.preventDefault();
      toggle();
    }

    if (isOuterClick) {
      event.preventDefault();
      close();
    }
  });
}
