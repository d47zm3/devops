
import isLoggedIn from '../config/tulo';

window.onload = () => {
  const adblockerCloseBtn = document.getElementById('adblocker-close-btn');
  const disableAdblockMessageBtn = document.getElementById('disable-adblock-message-btn');
  const adblockerWrapper = document.getElementById('adblocker-wrapper');
  const adblockerLoggedIn = document.getElementById('adblocker-logged-in');
  const adblockerLoggedOut = document.getElementById('adblocker-logged-out');
  const adblockMessageSeen = sessionStorage.getItem('adblock_msg_seen');
  const adblockMessageDisabled = localStorage.getItem('adblock_msg_disabled');

  if (adblockerWrapper) {
    const hideAdblockMessage = (e) => {
      e.preventDefault();
      adblockerWrapper.setAttribute('hidden', true);
    };
    const disableAdblockMessage = (e) => {
      e.preventDefault();
      localStorage.setItem('adblock_msg_disabled', 1);
      hideAdblockMessage(e);
    };

    // exit, do not show message
    if (isLoggedIn() && adblockMessageDisabled) {
      return;
    }

    // prepare specific message
    if (isLoggedIn()) {
      adblockerLoggedIn.removeAttribute('hidden');
    } else {
      adblockerLoggedOut.removeAttribute('hidden');
    }

    // show adblock message 1 time in session
    if (!adblockMessageSeen && window.isAdblock) {
      adblockerWrapper.removeAttribute('hidden');
      sessionStorage.setItem('adblock_msg_seen', 1);
    }

    adblockerCloseBtn.addEventListener('click', hideAdblockMessage);
    disableAdblockMessageBtn.addEventListener('click', disableAdblockMessage);
  }
};
