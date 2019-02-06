import axios from 'axios';
import svg4everybody from 'svg4everybody';

const containerClass = 'js-svg-sprite';
const spriteUrlData = 'data-url';

const container = document.querySelector(`.${containerClass}`);

if (container) {
  const spriteUrl = container.getAttribute(spriteUrlData);

  if (spriteUrl) {
    axios.get(spriteUrl)
      .then((response) => {
        container.innerHTML = response.data;
        svg4everybody();
      });
  }
}
