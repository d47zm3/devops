// Polyfills
import 'core-js/fn/array/from';
import 'core-js/fn/array/find';
import 'core-js/fn/object/entries';
import 'core-js/es6/promise';
import 'element-closest';
import 'intersection-observer';
import smoothscroll from 'smoothscroll-polyfill';

// Components
import './components/header';
import './components/footer';
import './components/mega-menu';
import './components/navigation';
import './components/side-nav';
import './components/input';
import './components/reveal';
import './components/cookie-info';
import './components/svg-sprite';
import './components/article-loader';
import './components/login-tulo';
import './components/back-to-top';
import './components/subscriptions';
import './components/login-tooltip';
import './components/modal';
import './components/accordion';
import './components/adblocker';
import './components/important-news';
import './components/social-share';

import gallery from './components/gallery';
import lightbox from './components/lightbox';
import paywall from './components/paywall';
import lazyload from './components/images-lazyload';

// App start
(function app() {
  gallery(document);
  lightbox(document);
  paywall(document);
  lazyload();
  smoothscroll.polyfill();
})();
