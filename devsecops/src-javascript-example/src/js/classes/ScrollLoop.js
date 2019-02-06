export default class ScrollLoop {
  constructor({
    debounceTime = 50,
  } = {}) {
    this.onUpdate = [];
    this.onStart = [];
    this.onStop = [];

    // How long should debounce wait
    this.debounceTime = debounceTime;

    // Is scrolling loop looping
    this.isScrolling = false;

    this.mainLoop = this.mainLoop.bind(this);
    this.scrollHandler = this.scrollHandler.bind(this);

    this.init();
  }

  // Main loop running if user is scrolling
  mainLoop() {
    // Update state
    this.onUpdate.forEach((fn) => fn());

    if (this.isScrolling) {
      requestAnimationFrame(this.mainLoop);
    }
  }

  addOnUpdate(fn) {
    this.onUpdate.push(fn);
  }

  addOnStart(fn) {
    this.onStart.push(fn);
  }

  addOnStop(fn) {
    this.onStop.push(fn);
  }

  // Handle scroll start
  onScrollStart() {
    // Start main loop condition
    this.isScrolling = true;

    // Run main loop
    this.mainLoop();
  }

  onScrollStop() {
    // Stop main loop condition
    this.isScrolling = false;
    this.onStop.forEach((fn) => fn());
  }

  // Simplistic debounce adaptation with start and stop hooks
  scrollHandler() {
    let timeout = null;

    return () => {
      clearTimeout(timeout);

      if (!timeout) {
        this.onStart.forEach((fn) => fn());
        this.onScrollStart();
      }

      timeout = setTimeout(() => {
        timeout = null;
        this.onScrollStop();
      }, this.debounceTime);
    };
  }

  init() {
    // Attach debounced function to scroll event
    window.addEventListener('scroll', this.scrollHandler());
  }
}
