import axios from 'axios';
import qs from 'qs';
import subscriptions from '../views/subscriptions';

const subscriptionContainer = document.getElementById('subscription-container');
const mobileSubscriptionContainer = document.getElementById('mobile-subscription-container');
const isTulo = typeof window.Tulo !== 'undefined';
const isInfomaker = typeof window.infomaker !== 'undefined';

// generate HTML from issue object list
const generateHTML = (issues) => {
  const fragment = document.createDocumentFragment();
  const container = document.createElement('div');
  let html = '';

  if (issues.length) {
    html = subscriptions(issues).join('');
  }

  container.classList.add('subscription-list');
  container.innerHTML = html;
  // Add subscriptions to megamenu
  fragment.appendChild(container);
  subscriptionContainer && subscriptionContainer.appendChild(fragment);
};

const generateMobileHtml = (issues) => {
  if (issues.length) {
    const fragment = document.createDocumentFragment();
    const container = document.createElement('div');

    const listItems = issues.map((data) => `
        <li class="user-actions__item">
          <a href="${data.url}" class="user-actions__link">${data.title}</a>
        </li>
      `);

    container.innerHTML = `<ul class="user-actions user-actions--mobile clear-list">${listItems.join('')}</ul>`;
    fragment.appendChild(container);
    mobileSubscriptionContainer && mobileSubscriptionContainer.appendChild(fragment);
  }
};

const getEpapers = (productList, url) => {
  const data = qs.stringify({
    action: 'get_epaper_issues_based_on_products',
    product: productList,
  });
  return axios({
    url,
    data,
    method: 'post',
  });
};

const displayEpapers = (tuloData, infomakerData) => {
  if (tuloData.products.length) {
    // ajax call
    const xhr = getEpapers(tuloData.products, infomakerData.ajaxurl);
    xhr.then((response) => {
      generateHTML(response.data.data.issues);
      generateMobileHtml(response.data.data.issues);
    });
  }
};

// Load e-papers if possible
if (isTulo && isInfomaker) {
  if (window.Tulo.logged_in()) {
    const infomakerData = window.infomaker;
    window.Tulo.session((tuloData) => displayEpapers(tuloData, infomakerData));
  }
}
