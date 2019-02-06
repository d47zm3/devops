const navigationRootClass = 'navigation';
const navigationElementClass = 'navigation__element';
const navigationLinkClass = 'navigation__link';
const activeClass = 'active';
const sectionData = 'data-section';
const sectionClassPart = 'section-theme--';


const navigationRootElement = document.querySelector(`.${navigationRootClass}`);

if (navigationRootElement) {
  const navigationElements = Array.from(navigationRootElement.querySelectorAll(`.${navigationElementClass}`));

  const inactivateElements = () => {
    navigationElements.forEach((element) => element.classList.remove(activeClass));
  };

  const removeSectionClass = () => {
    const classes = Array.from(document.body.classList);
    const sectionClasses = classes.filter((cls) => cls.includes(sectionClassPart));
    if (sectionClasses.length) {
      document.body.classList.remove(...sectionClasses);
    }
  };

  const setActiveByLink = (linkElement) => {
    const navigationElement = linkElement.parentElement;

    if (!navigationElement.classList.contains(activeClass)) {
      const sectionName = navigationElement.getAttribute(sectionData);
      inactivateElements();
      removeSectionClass();

      navigationElement.classList.add(activeClass);
      document.body.classList.add(sectionClassPart + sectionName);
    }
  };

  navigationRootElement.addEventListener('click', ({ target }) => {
    if (target && target.classList.contains(navigationLinkClass)) {
      setActiveByLink(target);
    }
  });
}
