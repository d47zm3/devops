import debounce from 'lodash/debounce';
import StickyScroll from '../classes/StickyScroll';
import { HEADER_FIXED_CLASS, HEADER_NAV_ONLY_CLASS } from '../config/constants';
import { cssIsSupported } from '../misc/helpers';

const supportSticky = cssIsSupported('position', 'sticky');
const headerClass = 'js-header';
const interchangeClass = 'js-interchange';
const interchangeChangeClass = 'interchange--changed';
const topClass = 'header__top';
const overHeaderClass = 'over-header';

const header = document.querySelector(`.${headerClass}`);

if (header && supportSticky) {
  const interchange = header.querySelector(`.${interchangeClass}`);
  const headerTop = header.querySelector(`.${topClass}`);
  const overHeader = document.querySelector(`.${overHeaderClass}`);

  const getMaxTransform = () => headerTop.offsetHeight;
  const getMargin = () => (overHeader ? overHeader.offsetHeight : 0);

  const scrollStop = function scrollStopHook() {
    if (this.isClosed() === true) {
      document.body.classList.add(HEADER_NAV_ONLY_CLASS);
      if (interchange) {
        interchange.classList.add(interchangeChangeClass);
      }
    } else {
      document.body.classList.remove(HEADER_NAV_ONLY_CLASS);
      if (interchange) {
        interchange.classList.remove(interchangeChangeClass);
      }
    }
  };

  const stickyScroll = new StickyScroll(header);

  stickyScroll
    .setMaxTransform(getMaxTransform())
    .setMargin(getMargin())
    .setOnScrollUpdate(scrollStop);


  const onScroll = () => {
    let wasOnTop = true;

    return () => {
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

      if (scrollTop <= 0 && !wasOnTop) {
        document.body.classList.remove(HEADER_FIXED_CLASS);
        wasOnTop = true;
      } else if (scrollTop > 0 && wasOnTop) {
        document.body.classList.add(HEADER_FIXED_CLASS);
        wasOnTop = false;
      }
    };
  };

  const initHeaderState = () => {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (scrollTop > 0) {
      document.body.classList.add(HEADER_FIXED_CLASS);
    }
  };

  const onResize = () => {
    stickyScroll
      .setMaxTransform(getMaxTransform())
      .setMargin(getMargin());
  };

  initHeaderState();
  window.addEventListener('scroll', debounce(onScroll(), 20));
  window.addEventListener('resize', debounce(onResize, 200));
}
