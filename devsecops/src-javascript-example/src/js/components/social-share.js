import qs from 'qs';

const shareClass = 'js-social-share';
const dataHref = 'data-href';
const dataDescription = 'data-description';
const dataTitle = 'data-title';
const dataPlatform = 'data-platform';
const twitterShareBaseUrl = 'https://twitter.com/intent/tweet';
const linkedInSharebaseUrl = 'https://www.linkedin.com/shareArticle';

const handleFacebookShare = (element) => {
  if (window.FB != null && window.FB.ui != null) {
    const href = element.getAttribute(dataHref);

    const shareObject = {
      method: 'share',
      href,
    };

    window.FB.ui(shareObject, () => {});
  }
};

const openPopup = (url, title, width = 640, height = 440) => {
  const left = (window.screen.width / 2) - (width / 2);
  const top = (window.screen.height / 2) - (height / 2);
  const newPopup = window.open(url, title, `height=${height},width=${width},top=${top},left=${left}`);

  if (window.focus) {
    newPopup.focus();
  }

  return false;
};

const createTwitterShareUrl = (base, text, url) => {
  const twitterObject = {
    text,
    url,
  };

  const querySelector = qs.stringify(twitterObject);
  return `${base}?${querySelector}`;
};

const createLinkedInShareUrl = (base, title, url) => {
  const twitterObject = {
    url,
    title: title.length > 200 ? `${title.substring(0, 197)}...` : title,
    mini: true,
  };

  const querySelector = qs.stringify(twitterObject);
  return `${base}?${querySelector}`;
};

const handleTwitterShare = (element) => {
  const text = element.getAttribute(dataDescription);
  const href = element.getAttribute(dataHref);
  const title = element.getAttribute(dataTitle);
  const url = createTwitterShareUrl(twitterShareBaseUrl, text, href);

  openPopup(url, `Share on Twitter: ${title}`);
};

const handleLinkedInShare = (element) => {
  const href = element.getAttribute(dataHref);
  const title = element.getAttribute(dataTitle);
  const url = createLinkedInShareUrl(linkedInSharebaseUrl, title, href);

  openPopup(url, `Share on Linked In: ${title}`, 974, 500);
};

const handleMailShare = (element) => {
  const body = element.getAttribute(dataDescription);
  const href = element.getAttribute(dataHref);
  const title = element.getAttribute(dataTitle);

  const mailtoObject = {
    body: [body, href].join('\n'),
    subject: title,
  };

  const queryString = qs.stringify(mailtoObject);

  window.location.href = `mailto:?${queryString}`;
};

const handleClick = (event) => {
  if (event.target) {
    const target = event.target.closest(`.${shareClass}`);
    if (target != null) {
      event.preventDefault();
      const platform = target.getAttribute(dataPlatform);

      switch (platform.toLowerCase()) {
        case 'facebook':
          handleFacebookShare(target);
          break;

        case 'twitter':
          handleTwitterShare(target);
          break;

        case 'linked-in':
          handleLinkedInShare(target);
          break;

        case 'mail':
          handleMailShare(target);
          break;

        default:
          break;
      }
    }
  }
};

document.addEventListener('click', handleClick);
