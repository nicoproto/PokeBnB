import { Controller } from '@hotwired/stimulus';

import AOS from 'aos';

export default class extends Controller {
  connect() {
    window.addEventListener('load', () => {
      AOS.init();
    })
  }
}



