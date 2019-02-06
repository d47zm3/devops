import qs from 'qs';

const originPrefix = 'nwt-';
const queryCollection = {};
const tuloButtonClass = 'js-paywall-btn';
const paywallClass = 'js-paywall';
const inViewClass = 'js-paywall-in';

let inViewTimer = null;

/**
 * Get origin
 *
 * @returns {string}
 */
const getOrigin = () => originPrefix + window.location.hostname;

/**
 * Get persisted query id
 *
 * @returns {string}
 */
const getPersistedQueryId = () => (
  (window.infomaker.settings.cxense && window.infomaker.settings.cxense.persistedQueryId)
    ? window.infomaker.settings.cxense.persistedQueryId
    : 'e4995e35ac2954a02732b1774d280f898a38bfd4'
);

/**
 * Collect data from query string
 */
const collectDataFromQueryString = () => {
  window.location.search.substr(1).split('&').forEach((item) => {
    const [key, value] = item.split('=');
    queryCollection[key] = value;
  });
};

/**
 * Send Cxense event
 *
 * @param eventName
 * @param actionName
 */
const cxenseSendEvent = (eventName, actionName) => {
  if (window.cX) {
    window.cX.callQueue.push([
      'setEventAttributes',
      {
        origin: getOrigin(),
        persistedQueryId: getPersistedQueryId(),
      },
    ]);

    window.cX.callQueue.push([
      'sendEvent',
      eventName,
      {
        action: actionName,
      },
    ]);
  }
};

/**
 * Update url of tulo button by setting returnUrl
 *
 * @param context - DOM element in which paywall exists
 * @param url - url to be set ad returnUrl
 */
const setReturnUrl = (context, url) => {
  const button = context.querySelector(`.${tuloButtonClass}`);

  if (button) {
    let queryString = button.search;

    queryString = queryString.charAt(0) === '?'
      ? queryString.slice(1)
      : queryString;

    const queryData = qs.parse(queryString);

    if (queryData && queryData.returnUrl === '') {
      queryData.returnUrl = url;
      button.search = qs.stringify(queryData);
    }
  }
};

/**
 * Setup events for paywall
 */
const setupEvents = () => {
  // Tulo btn click
  document.addEventListener('click', (event) => {
    if (event.target && event.target.closest(`.${tuloButtonClass}`)) {
      cxenseSendEvent('paywall', 'transaction-begin');
    }
  });

  // Check query if order completed
  if (queryCollection.orderStatus === 'closed') {
    cxenseSendEvent('paywall', 'transaction-completed');
  }
};

/**
 * Send event to Cxsense if paywall have to presented
 *
 * @param element
 */
const cxenseTeaserViewedNotifier = (element) => {
  if (inViewTimer) {
    clearTimeout(inViewTimer);
  }

  inViewTimer = setTimeout(() => {
    if (element.matches(`.${inViewClass}`)) {
      cxenseSendEvent('paywall', 'teaser-viewed');
    }
  }, 1500);
};

/**
 * Track paywall inview
 */
const registerPaywallInview = (context) => {
  const paywalls = Array.from(context.querySelectorAll(`.${paywallClass}`));
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.intersectionRatio > 0) {
        entry.target.classList.add(inViewClass);
        cxenseTeaserViewedNotifier(entry.target);
      } else {
        entry.target.classList.remove(inViewClass);
      }
    });
  });

  paywalls.forEach(paywall => {
    observer.observe(paywall);
  });
};

const init = (context) => {
  collectDataFromQueryString();
  setupEvents();
  registerPaywallInview(context);
};

export const update = (context, url) => {
  setReturnUrl(context, url);
  registerPaywallInview(context);
};
export default init;
