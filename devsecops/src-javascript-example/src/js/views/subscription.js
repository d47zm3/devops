const subscription = (data) => `<div class="subscription-list__item">
    <a class="subscription-preview" href="${data.url}">
      <div class="subscription-preview__cover">
        <img src="${data.image.url}" alt="${data.image.alt}" class="subscription-preview__thumb">
      </div>
      <div class="subscription-preview__title">
        ${data.title}
      </div>
    </a>
  </div>`;

export default subscription;
