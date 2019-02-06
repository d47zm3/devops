import ScrollLoop from '../classes/ScrollLoop';

const articleClass = 'js-progress-element';
const progressBarClass = 'js-progress-indicator';

const articles = Array.from(document.querySelectorAll(`.${articleClass}`));
const progress = Array.from(document.querySelectorAll(`.${progressBarClass}`));

if (articles.length > 0 && progress.length > 0) {
  const scrollLoop = new ScrollLoop();

  let lastPercent = 0;

  const getScrollPercent = (el) => {
    const viewportBottom = window.pageYOffset + window.innerHeight;
    const relativePosition = Math.max(viewportBottom - el.offsetTop, 0);
    const fraction = Math.min(relativePosition / el.scrollHeight, 1);
    return Math.round(fraction * 1000) / 1000;
  };

  const render = (scaleValue) => {
    progress.forEach((element) => {
      // eslint-disable-next-line no-param-reassign
      element.style.cssText = `
        -webkit-transform: scaleX(${scaleValue});
        -moz-transform: scaleX(${scaleValue});
        -ms-transform: scaleX(${scaleValue});
        -o-transform: scaleX(${scaleValue});
        transform: scaleX(${scaleValue});
      `;
    });
  };

  const update = () => {
    const percentages = articles.map((article) => getScrollPercent(article));
    const percent = percentages.filter((percentVelus) => percentVelus < 1 && percentVelus > 0)[0];

    if (typeof percent !== 'undefined' && lastPercent !== percent) {
      lastPercent = percent;
      render(percent);
    }
  };

  update();
  scrollLoop.addOnUpdate(update);
}
