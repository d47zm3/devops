const backToTopClass = 'js-back-to-top';
const backToTop = document.querySelector(`.${backToTopClass}`);

if (backToTop) {
  const onClick = (event) => {
    event.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
    });
  };

  backToTop.addEventListener('click', onClick);
}
