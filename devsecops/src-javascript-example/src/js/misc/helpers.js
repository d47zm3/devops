import { CSS_VENDOR_PREFIXES } from '../config/constants';

export const cssIsSupported = (property, value) => {
  const test = document.head.style;

  if (test[property] === undefined) return false;

  for (let i = 0; i < CSS_VENDOR_PREFIXES.length; i += 1) {
    test[property] = `${CSS_VENDOR_PREFIXES[i]}${value}`;
  }

  const isSupported = !!test[property];
  test[property] = '';

  return isSupported;
};

export const getURLParameter = (_name, _url) => {
  const url = !_url ? window.location.href : _url;
  const name = _name.replace(/[\[\]]/g, '\\$&'); // eslint-disable-line no-useless-escape
  const regex = new RegExp(`[?&]${name}(=([^&#]*)|&|#|$)`);
  const results = regex.exec(url);

  if (!results) {
    return null;
  }

  if (!results[2]) {
    return '';
  }

  return decodeURIComponent(results[2].replace(/\+/g, ' '));
};
