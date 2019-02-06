import Cookies from 'js-cookie';
import { COOKIE_LOGIN_TOOLTIP, COOKIE_PAGE_VIEWS } from '../config/constants';
import isLoggedIn from '../config/tulo';

const loginTooltip = document.getElementById('login-tooltip');
const loginTooltipCookie = Cookies.get(COOKIE_LOGIN_TOOLTIP);
let pageViewsCookie = Cookies.get(COOKIE_PAGE_VIEWS);

const displayTooltip = () => {
  loginTooltip.removeAttribute('hidden');
};

const pageViewsCount = () => {
  if (pageViewsCookie == null) {
    Cookies.set(COOKIE_PAGE_VIEWS, 1);
  } else if (pageViewsCookie < 5) {
    pageViewsCookie = parseInt(pageViewsCookie, 0) + 1;
    Cookies.set(COOKIE_PAGE_VIEWS, pageViewsCookie);
  }
};

if (isLoggedIn()) {
  Cookies.remove(COOKIE_LOGIN_TOOLTIP);
  Cookies.remove(COOKIE_PAGE_VIEWS);
} else {
  // start counting page views
  pageViewsCount();
  // display each 5 page view
  if (pageViewsCookie === 5) {
    displayTooltip();
    Cookies.remove(COOKIE_PAGE_VIEWS);
  }
  // 3-day tooltip
  if (loginTooltipCookie == null) {
    displayTooltip();
    Cookies.set(COOKIE_LOGIN_TOOLTIP, 1, { expires: 3 });
  }
}
