export default class MegaMenu {
  constructor(element) {
    this.config = MegaMenu.getConfig();
    this.element = element;
    this.focusableElements = this.getFocusableElements();
    this.id = element.id;
    this.triggers = this.getTriggers();
    this.isOpened = false;
    this.init();
  }

  static getConfig() {
    return {
      rootClass: 'mega-menu',
      activeClass: 'opened',
      triggerAttribute: 'data-mega-menu-target',
      focusableElements: [
        'input',
        'textarea',
        'a',
        'button',
      ],
    };
  }

  getTriggers() {
    return Array.from(document.querySelectorAll(`[${this.config.triggerAttribute}="${this.id}"]`));
  }

  getFocusableElements() {
    return Array.from(this.element.querySelectorAll(this.config.focusableElements.join(',')));
  }

  a11yHide() {
    this.element.setAttribute('aria-hidden', true);

    this.focusableElements.forEach((element) => {
      element.setAttribute('tabindex', '-1');
    });
  }

  a11yShow() {
    this.element.setAttribute('aria-hidden', false);

    this.focusableElements.forEach((element) => {
      element.removeAttribute('tabindex');
    });
  }

  open() {
    if (!this.isOpened) {
      this.isOpened = true;
      this.element.focus();
      this.update();
    }
  }

  close() {
    if (this.isOpened) {
      this.isOpened = false;
      this.update();
    }
  }

  toggle() {
    this.isOpened = !this.isOpened;
    this.update();
  }

  update() {
    if (this.isOpened) {
      this.element.classList.add(this.config.activeClass);
      this.triggers.forEach((trigger) => trigger.classList.add(this.config.activeClass));
      this.a11yShow();
    } else {
      this.element.classList.remove(this.config.activeClass);
      this.triggers.forEach((trigger) => trigger.classList.remove(this.config.activeClass));
      this.a11yHide();
    }
  }

  init() {
    this.a11yHide();
  }
}
