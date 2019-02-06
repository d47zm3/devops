export const getImageSlide = (url, uuid) => `
  <div class="swiper-slide" data-id="${uuid}">
    <div class="lightbox__image-wrapper">
      <div class="lightbox__image" style="background-image: url('${url}')"></div>
    </div>
  </div>
`;

export const getTextSlide = ({
  currentSlide,
  slidesCount,
  text,
  author,
  shareDescription,
  shareHref,
  shareTitle,
}) => {
  let authorName = '';

  if (author != null && author !== '') {
    try {
      authorName = JSON.parse(author).map((a) => a.title).join('<br />');
    } catch (e) {
      console.warn(e); // eslint-disable-line no-console
    }
  }

  return `
    <div class="swiper-slide">
      <div class="lightbox__text-content">
        <div class="lightbox__slide">
          <span class="lightbox__slide-current">${currentSlide}</span> / ${slidesCount}
        </div>
        <div class="lightbox__image-description">
          ${text}
        </div>
        <div class="lightbox__image-author">
          Bild: ${authorName}
        </div>
        <div class="lightbox__share-box">
          <div class="lightbox__share-label">
            Dela bilden
          </div>
          <div class="lightbox__share-list">
            <ul class="inline-list inline-list--space-2">
              <li class="inline-list__item">
                <a
                  href="#"
                  class="lightbox__share-icon js-social-share"
                  data-platform="facebook"
                  data-href="${shareHref}"
                  data-description="${shareDescription}"
                  data-title="${shareTitle}"
                >
                <svg class="icon icon--block">
                  <use xlink:href="#facebook"></use>
                </svg>
                </a>
              </li>
              <li class="inline-list__item">
                <a href="#" class="lightbox__share-icon js-social-share"
                  data-platform="twitter"
                  data-href="${shareHref}"
                  data-description="${shareDescription}"
                  data-title="${shareTitle}"
                >
                <svg class="icon icon--block">
                  <use xlink:href="#twitter"></use>
                </svg>
                </a>
              </li>
              <li class="inline-list__item">
                <a href="#" class="lightbox__share-icon js-social-share"
                  data-platform="mail"
                  data-href="${shareHref}"
                  data-description="${shareDescription}"
                  data-title="${shareTitle}"
                >
                  <svg class="icon icon--block">
                    <use xlink:href="#mail"></use>
                  </svg>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  `;
};
