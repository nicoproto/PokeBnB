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
        container: this.mapTarget,
        style: 'mapbox://styles/mapbox/streets-v10'
      });

      const markers = JSON.parse(this.mapTarget.dataset.markers);

      this.addMarkersToMap(map, markers);
      this.fitMapToMarkers(map, markers);
    }
  }

  addMarkersToMap(map, markers) {
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window);

      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(map);
    });
  }

  fitMapToMarkers(map, markers) {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    map.fitBounds(bounds, {
      padding: 70,
      maxZoom: 15,
      duration: 0
    });
  };

}