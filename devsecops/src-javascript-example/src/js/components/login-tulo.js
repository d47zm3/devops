import Cookies from 'js-cookie';
import { FORM_ERRORS } from '../config/constants';
import { getURLParameter } from '../misc/helpers';
import isLoggedIn from '../config/tulo';

const errorContainers = Array.from(document.querySelectorAll('.js-login-error-container'));
const userLogoutButtons = Array.from(document.querySelectorAll('.js-login-logout-trigger'));
const loginIcon = document.getElementById('login-icon');
const welcomeMessageBox = document.getElementById('welcome-message-box');
const tuloErrorCode = getURLParameter('tulo_error');

const requestedFields = 'alias,contact_email,organisation,products,customer_number,first_name,last_name,mobile_number';

const renderError = (code) => {
  const errorCodeExists = Object.prototype.hasOwnProperty.call(FORM_ERRORS, code);

  return (container) => {
    if (FORM_ERRORS && errorCodeExists) {
      container.removeAttribute('hidden');
      container.textContent = FORM_ERRORS[code];
    }
  };
};

const logout = () => {
  Cookies.remove('T_ID');
  window.Tulo.logout(`${window.location}?auth=false`);
};

const logoutTriggerHandler = (trigger) => {
  trigger.addEventListener('click', (event) => {
    event.preventDefault();
    logout();
  });
};

const displayWelcomeMessage = (name) => {
  if (welcomeMessageBox) {
    welcomeMessageBox.innerHTML = `${name}`;
  }
};

const getPersistedQueryId = () => (
  (window.infomaker.settings.cxense && window.infomaker.settings.cxense.persistedQueryId)
    ? window.infomaker.settings.cxense.persistedQueryId
    : 'e4995e35ac2954a02732b1774d280f898a38bfd4'
);

// Set all stuff if user is properly logged in
if (isLoggedIn()) {
  document.body.classList.add('tulo-logged-in');
  loginIcon.classList.remove('icon--bounce');
}

if (typeof window.Tulo !== 'undefined' && typeof window.infomaker !== 'undefined') {
  // Tulo loaded
  const Auth = window.infomaker.auth;
  // init
  if (window.Safari11Fallback) {
    window.Safari11Fallback.setFallbackToken();
    window.Tulo.init(
      Auth.client,
      Auth.forward_uri,
      Auth.oid,
      {
        env: Auth.environment,
        fields: requestedFields,
        js_api_token: window.Safari11Fallback.getFallbackToken(),
      },
    );
  } else {
    window.Tulo.init(Auth.client, Auth.forward_uri, Auth.oid, {
      env: Auth.environment,
      fields: requestedFields,
    });
  }

  window.Tulo.session((data) => {
    // Send data to Cxense about login status
    if (typeof window.cX !== 'undefined') {
      if (typeof window.cX.setEventAttributes !== 'undefined') {
        window.cX.setEventAttributes({
          origin: `nwt-${window.location.hostname}`,
          persistedQueryId: getPersistedQueryId(),
        });
      }

      if (typeof window.cX.sendEvent !== 'undefined') {
        window.cX.sendEvent('logged-in', {
          action: `logged-in-${(data && data.active)}`,
        });
      }
    }

    // set welcome message if logged-in
    if (Auth.logged_in && data.active && data.first_name) {
      displayWelcomeMessage(data.display_name);
    }

    // Check if user is logged in Tulo but logged out in Everyware
    if (typeof Auth.logged_in !== 'undefined' && data.active === true && Auth.logged_in === false) {
      try {
        // Prevent refresh loop
        if (sessionStorage.getItem('autoreload') !== 'true') {
          sessionStorage.setItem('autoreload', 'true');
          window.location.reload();
        }
      } catch (e) {} // eslint-disable-line no-empty
    }

    // display welcome-message-box
    // welcomeMessageBox.removeAttribute('hidden');
    // welcomeMessageBox.classList.add('displayed');
  });

  // Login Out
  if (userLogoutButtons.length > 0) {
    userLogoutButtons.forEach(logoutTriggerHandler);
  }

  // Check for errors
  if (tuloErrorCode !== '') {
    // try render proper error message
    errorContainers.forEach(renderError(tuloErrorCode));
  }

  window.Tulo.register_event_listener('session_status_changed', () => {
    window.location.reload();
  });
}
