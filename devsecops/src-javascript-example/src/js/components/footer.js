import debounce from 'lodash/debounce';

const rootClass = 'js-footer';
const contentClass = 'js-footer-content';

const root = document.querySelector(`.${rootClass}`);
const content = document.querySelector(`.${contentClass}`);

if (root && content) {
  const getContentHeight = () => content.offsetHeight;
  const setRootHeight = (height) => { root.style.minHeight = `${height}px`; };
  const update = () => setRootHeight(getContentHeight());

  update();
  window.addEventListener('resize', debounce(update, 200));
}
