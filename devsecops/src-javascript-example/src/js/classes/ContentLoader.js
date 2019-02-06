import axios from 'axios';

export default class ContentLoader {
  constructor({
    url,
    page = 0,
    params = {},
  }) {
    this.page = page;
    this.params = params;
    this.url = url;
  }

  request() {
    return axios.get(this.url, {
      params: Object.assign({}, { page: this.page }, this.params),
    });
  }

  requestData() {
    return this.request()
      .then((response) => {
        this.incrementPage();
        return response.data;
      });
  }

  incrementPage() {
    this.page++;
  }

  decrementPage() {
    this.page--;
  }
}
