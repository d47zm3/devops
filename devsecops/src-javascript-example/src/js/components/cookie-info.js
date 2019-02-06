import Cookies from 'js-cookie';
import { COOKIE_INFO_NAME } from '../config/constants';

const cookieInfoClass = 'cookie-info';
const visibleClass = 'cookie-info--visible';
const buttonClass = 'cookie-info__button';

const cookieInfoBox = document.querySelector(`.${cookieInfoClass}`);

if (cookieInfoBox) {
  const isCookieSet = !!Cookies.get(COOKIE_INFO_NAME);

  if (!isCookieSet) {
    const actionButton = cookieInfoBox.querySelector(`.${buttonClass}`);
    const actionClickHandler = (event) => {
      event.preventDefault();
      Cookies.set(COOKIE_INFO_NAME, 1, { expires: 365, path: '/' });
      cookieInfoBox.classList.remove(visibleClass);
    };

    actionButton.addEventListener('click', actionClickHandler);
    cookieInfoBox.classList.add(visibleClass);
  }
}
