import { Controller } from '@hotwired/stimulus';

import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

export default class extends Controller {
  static targets = ['map'];

  connect() {
    // only build a map if there's a div#map to inject into
    if (this.mapTarget) {
      mapboxgl.accessToken = this.mapTarget.dataset.mapboxApiKey;
      const map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v10'
      });
    }
  }
}