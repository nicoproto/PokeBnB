import { Controller } from '@hotwired/stimulus';

import places from 'places.js';

export default class extends Controller {
  static targets = ['location'];

  connect() {
    places({
      container: this.locationTarget,
    });
  }
}