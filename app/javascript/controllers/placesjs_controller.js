import { Controller } from '@hotwired/stimulus';
import places from 'places.js';

export default class extends Controller {
  static targets = ['location'];

  connect() {
    places({
      container: this.locationTarget,
    });

    const locationBtn = document.querySelector('.ap-input-icon.ap-icon-pin');
    if (locationBtn) {
      locationBtn.addEventListener('click', () => this.getCurrentLocation());
    }
  }

  async getCurrentLocation() {
    navigator.geolocation.getCurrentPosition(this.showPosition)
  }

  showPosition(position) {
    document.getElementById("location").value = [position.coords.latitude, position.coords.longitude];
    document.querySelector('form').submit();
  }
}
