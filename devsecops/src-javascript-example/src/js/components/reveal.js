const rootClass = 'reveal';
const notVisibleClass = 'reveal--not-visible';

// Create new IntersectionObserver instance
const io = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    // Element is not in viewport at page load
    if (!entry.isIntersecting) {
      entry.target.classList.add(notVisibleClass);
    }

    // Element is in viewport
    if (entry.isIntersecting) {
      entry.target.classList.remove(notVisibleClass);
      io.unobserve(entry.target);
    }
  });
});

// Elements to be observed
const elements = Array.from(document.querySelectorAll(`.${rootClass}`));

elements.forEach((element) => {
  io.observe(element);
});
