import LazyLoad from 'vanilla-lazyload/dist/lazyload.amd';

const lazyloadClass = 'js-lazy-load';

let lazyloadSIngleton = null;

export default () => {
  if (lazyloadSIngleton === null) {
    lazyloadSIngleton = new LazyLoad({
      elements_selector: `.${lazyloadClass}`,
    });
  }

  return lazyloadSIngleton;
};
