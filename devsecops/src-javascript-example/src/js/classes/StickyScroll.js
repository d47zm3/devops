import ScrollLoop from './ScrollLoop';

export default class StickyScroll {
  constructor(target, {
    maxTransform = null,
    margin = 0,
  } = {}) {
    // Setup configurable variables
    this.target = target;

    // Max offset
    this.maxTransform = maxTransform === null ? target.clientHeight : maxTransform;

    // Scroll position from last loop
    this.lastScroll = StickyScroll.getScrollY();

    // Current transform value
    this.offset = 0;

    // Header transform value from last loop
    this.lastOffset = 0;

    // top margin to activate
    this.margin = margin;

    this.scrollLoop = new ScrollLoop();

    this.init();
  }

  static getScrollY() {
    return window.pageYOffset || document.documentElement.scrollTop;
  }

  setMaxTransform(value) {
    this.maxTransform = value;
    return this;
  }

  setMargin(value) {
    this.margin = value;
    return this;
  }

  setOnScrollStart(fn) {
    this.scrollLoop.addOnStart(fn.bind(this));
    return this;
  }

  setOnScrollStop(fn) {
    this.scrollLoop.addOnStop(fn.bind(this));
    return this;
  }

  setOnScrollUpdate(fn) {
    this.scrollLoop.addOnUpdate(fn.bind(this));
    return this;
  }

  isClosed() {
    return this.offset === this.maxTransform;
  }

  // Update UI
  render() {
    this.target.style.cssText = `
      -webkit-transform: translateY(-${this.offset}px);
         -moz-transform: translateY(-${this.offset}px);
          -ms-transform: translateY(-${this.offset}px);
           -o-transform: translateY(-${this.offset}px);
              transform: translateY(-${this.offset}px);
    `;
  }

  // Update state
  update() {
    const currentScroll = StickyScroll.getScrollY() - this.margin;

    if (currentScroll > 0) {
      const deltaScroll = currentScroll - this.lastScroll;

      this.lastScroll = currentScroll;

      // limit header offset to [0 - headerHeight]
      this.offset = Math.max(Math.min(this.offset + deltaScroll, this.maxTransform), 0);

      // Update UI if offset changed
      if (this.lastOffset !== this.offset) {
        this.lastOffset = this.offset;
        this.render();
      }
    } else if (this.offset > 0) {
      this.offset = 0;
      this.lastOffset = 0;
      this.render();
    }
  }

  init() {
    this.scrollLoop.addOnUpdate(this.update.bind(this));
  }
}
