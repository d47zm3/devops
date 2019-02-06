const modalRootClass = 'js-modal';
const modalContentClass = 'js-modal-content';
const modalCloseClass = 'js-modal-close';
const modalDataTrigger = 'data-modal-trigger';

const modals = Array.from(document.querySelectorAll(`.${modalRootClass}`));

const initModal = (modal) => {
  const modalId = modal.getAttribute('id');
  const closeButtons = Array.from(modal.querySelectorAll(`.${modalCloseClass}`));
  const modalContent = modal.querySelector(`.${modalContentClass}`);
  let isOpened = false;

  const open = () => {
    modal.removeAttribute('hidden');
    isOpened = true;
  };

  const close = () => {
    modal.setAttribute('hidden', '');
    isOpened = false;
  };

  const toggle = () => {
    isOpened
      ? close()
      : open();
  };

  closeButtons.forEach((button) => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      close();
    });
  });

  modal.addEventListener('click', () => {
    close();
  });

  modalContent.addEventListener('click', (event) => {
    event.stopPropagation();
  });

  return {
    id: modalId,
    open,
    close,
    toggle,
  };
};

const modalInstances = modals.map(initModal);

const bodyClickHandler = (event) => {
  if (event.target != null) {
    const clickTarget = event.target.closest(`[${modalDataTrigger}]`);

    if (clickTarget != null) {
      const modal = modalInstances
        .find((instance) => instance.id === clickTarget.getAttribute(modalDataTrigger));

      if (modal != null) {
        event.preventDefault();
        modal.open();
      }
    }
  }
};

document.body.addEventListener('click', bodyClickHandler);
