import ContentLoader from '../classes/ContentLoader';
import lightbox from './lightbox';
import gallery from './gallery';
import scriptEval from './node-script-eval';
import { update as updatePaywall } from './paywall';
import lazyload from './images-lazyload';

// Cache used HTML attributes
const loadZoneClass = 'js-article-load-threshold';
const mainArticleClass = 'js-article-load-main';
const loaderClass = 'js-article-load-loader';
const scrollIndicationId = 'scroll-indictaion';
const dataPermalink = 'data-load-permalink';
const dataUuid = 'data-uuid';

// Cache used HTML elements
const loadZone = document.querySelector(`.${loadZoneClass}`);
const scrollIndication = document.getElementById(scrollIndicationId);
const isCxenseBot = () => (navigator.userAgent.toLowerCase().indexOf('cxensebot') !== -1);

// Test for data that should be on site to work properly
if (window.nwtInfiniteScrollData && loadZone) {
  const { meta, articles } = window.nwtInfiniteScrollData;
  articles.forEach(article => {
    article.isVisible = false;
  });

  const mainArticle = document.querySelector(`.${mainArticleClass}`);
  const loaderElement = loadZone.querySelector(`.${loaderClass}`);
  const intersectionOptions = {
    root: null,
    rootMargin: '0px',
    threshold: 0,
  };

  let isLoading = false;
  let counter = 1; // Start from 1 since first element is "main article"
  let activeArticle = mainArticle.getAttribute(dataUuid);
  let cxenseTimeout = null;

  const getArticleUrl = (uuid) => `${meta.url}${uuid}`;
  const getContentLoader = (url) => new ContentLoader({ url });
  const getDropElement = (uuid) => document.getElementById(uuid);
  const getNextArticle = () => (
    (counter < meta.count)
      ? articles[counter++]
      : null
  );

  const createOrUpdateMetaNode = (name, content) => {
    let node = null;

    if (name.indexOf('article:') === 0) {
      node = document.head.querySelector(`meta[property="${name}"]`);
    } else {
      node = document.head.querySelector(`meta[name="${name}"]`);
    }


    if (node == null) {
      node = document.createElement('meta');

      if (name.indexOf('article:') === 0) {
        node.setAttribute('property', name);
      } else {
        node.name = name;
      }
      document.head.appendChild(node);
    }

    node.content = content;
  };

  const createOrUpdateCxData = (cxData) => {
    cxData.forEach((element) => {
      Object.keys(element).forEach((key) => {
        createOrUpdateMetaNode(key, element[key]);
      });
    });
  };

  const isLastArticle = (uuid) => articles.findIndex(article => article.uuid === uuid) >= meta.count - 1;

  const setLoading = (state) => {
    isLoading = !!state;

    !isLoading
      ? loaderElement.setAttribute('hidden', '')
      : loaderElement.removeAttribute('hidden');
  };

  const onScrollIndicatorClick = (e) => {
    const id = scrollIndication.getAttribute('href');

    if (id != null) {
      const targetElement = document.getElementById(id.substr(1));
      e.preventDefault();

      targetElement.scrollIntoView({
        block: 'start',
        behavior: 'smooth',
      });
    }
  };

  const updateNextArticleBar = (uuid) => {
    if (scrollIndication) {
      if (isLastArticle(uuid)) {
        scrollIndication.hidden = true;
      } else {
        const activeArticleIndex = articles.findIndex(article => article.uuid === uuid);
        scrollIndication.hidden = false;
        scrollIndication.querySelector('.scroll-indication__article-title').innerText = articles[activeArticleIndex + 1].headline;
        scrollIndication.href = `#${articles[activeArticleIndex + 1].uuid}`;
      }
    }
  };

  const setUrl = (url) => {
    try {
      const newUrl = url.replace(/^http:\/\//i, 'https://');
      const currentUrl = window.location.href;

      if (newUrl !== currentUrl) {
        window.history.replaceState({}, null, newUrl);
      }
    } catch (e) {
      // eslint-disable-next-line no-console
      console.warn(e);
    }
  };

  const updateSifo = (articleData) => {
    // eslint-disable-next-line no-underscore-dangle
    const sifoData = window._cInfo;

    if (typeof sifoData !== 'undefined') {
      const locationHost = window.location.host.replace('www.', '');
      const tempAnchor = document.createElement('a');
      tempAnchor.href = articleData.permalink;

      const permalink = tempAnchor.pathname;
      const contentPath = `/${locationHost}${permalink}`;

      sifoData.push(
        { cmd: '_trackContentPath', val: contentPath },
        { cmd: '_executeTracking' },
      );
    }
  };

  const updateCxense = (articleData) => {
    if (typeof window.cX !== 'undefined') {
      if (cxenseTimeout) {
        clearTimeout(cxenseTimeout);
      }

      cxenseTimeout = setTimeout(() => {
        if (articleData && articleData.permalink) {
          window.cX.callQueue.push([
            'sendPageViewEvent',
            {
              location: articleData.permalink,
              referrer: articleData.permalink,
            },
          ]);
        } else {
          window.cX.callQueue.push(['sendPageViewEvent']);
        }
      }, 1000);
    }
  };

  const setActiveArticle = (articleUuid) => {
    activeArticle = articleUuid;

    const articleData = articles.find(article => article.uuid === articleUuid);

    if (articleData) {
      document.head.getElementsByTagName('title')[0].innerText = articleData.headline;
      setUrl(articleData.permalink);
      updateNextArticleBar(articleUuid);

      if (typeof articleData.cxense !== 'undefined') {
        createOrUpdateCxData(articleData.cxense);
      }

      updateSifo(articleData);
      updateCxense(articleData);
    }
  };

  const readIntersectionHandler = (entries) => {
    entries.forEach(entry => {
      const uuid = entry.target.getAttribute(dataUuid);
      const entryArticle = articles.find(article => article.uuid === uuid);
      entryArticle.isVisible = entry.isIntersecting;
    });

    const activeArticles = articles.filter(article => article.isVisible);

    const lastActiveArticle = activeArticles.length > 0
      ? activeArticles[activeArticles.length - 1]
      : null;

    if (lastActiveArticle !== null && activeArticle !== lastActiveArticle.uuid) {
      setActiveArticle(lastActiveArticle.uuid);
    }
  };

  const readIo = new IntersectionObserver(readIntersectionHandler, intersectionOptions);

  const regenerateArticle = (articleElement, articleUrl) => {
    gallery(articleElement);
    lightbox(articleElement);
    scriptEval(articleElement);
    updatePaywall(articleElement, articleUrl);
    lazyload().update();

    if (window.nwtDfpWrapper && window.nwtDfpWrapper.update) {
      window.nwtDfpWrapper.update();
    }
  };

  const handleNewContent = (response) => {
    if (response.success === true) {
      const wrapperElement = getDropElement(response.data.uuid);
      wrapperElement.innerHTML = response.data.output;
      const articleElement = wrapperElement.firstElementChild;
      articleElement.setAttribute(dataPermalink, response.data.url);
      regenerateArticle(articleElement, response.data.url);
      readIo.observe(articleElement);
    }

    setLoading(false);
  };

  const loadArticle = () => {
    const nexArticleData = getNextArticle();
    if (nexArticleData !== null) {
      const { uuid } = nexArticleData;
      const url = getArticleUrl(uuid);
      const contentLoader = getContentLoader(url);
      setLoading(true);

      try {
        contentLoader
          .requestData()
          .then(handleNewContent);
      } catch (e) {
        // eslint-disable-next-line no-console
        console.warn(e);
      }
    }
  };

  const loadIntersectionHandler = (entries) => {
    if (!isCxenseBot() && !isLoading) {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          loadArticle();
        }
      });
    }
  };

  const loadIo = new IntersectionObserver(loadIntersectionHandler, intersectionOptions);

  scrollIndication.addEventListener('click', onScrollIndicatorClick);
  readIo.observe(mainArticle);
  loadIo.observe(loadZone);
}
