const inputClass = 'input';
const inputFieldClass = `${inputClass}__field`;
const inputActiveClass = `${inputClass}--active`;
const inputRaisedClass = `${inputClass}--raised`;
const inputSelectClass = `${inputClass}--select`;

const inputs = Array.from(document.querySelectorAll(`.${inputClass}`));

if (inputs.length) {
  const isInputEmpty = (inputField) => !inputField.value.length;

  const isInputSelect = (inputWrapper) => inputWrapper.classList.contains(inputSelectClass);

  const onAutoFill = (inputWrapper, inputField) => {
    if (document.activeElement === inputField && isInputEmpty(inputField)) {
      inputWrapper.classList.remove(inputRaisedClass);
    }
  };

  const onFocus = (inputWrapper) => {
    inputWrapper.classList.add(inputActiveClass);

    if (!isInputSelect(inputWrapper)) {
      inputWrapper.classList.add(inputRaisedClass);
    }
  };

  const onBlur = (inputWrapper, inputField) => {
    inputWrapper.classList.remove(inputActiveClass);

    if (isInputEmpty(inputField)) {
      inputWrapper.classList.remove(inputRaisedClass);
    }
  };

  const onChange = (inputWrapper, inputField) => {
    if (!isInputEmpty(inputField) && !isInputSelect(inputWrapper)) {
      inputWrapper.classList.add(inputRaisedClass);
    }
  };

  inputs.forEach((inputWrapper) => {
    const inputField = inputWrapper.querySelector(`.${inputFieldClass}`);

    // Setup individual Handlers
    const focusHandler = onFocus.bind(this, inputWrapper);

    const blurHandler = ({ target }) => onBlur.call(this, inputWrapper, target);

    const changeHandler = ({ target }) => onChange.call(this, inputWrapper, target);

    // Setup event listeners
    inputField.addEventListener('focus', focusHandler);
    inputField.addEventListener('blur', blurHandler);
    inputField.addEventListener('change', changeHandler);

    window.setTimeout(() => onAutoFill(inputWrapper, inputField), 250);

    // Setup state
    onChange(inputWrapper, inputField);
  });
}
