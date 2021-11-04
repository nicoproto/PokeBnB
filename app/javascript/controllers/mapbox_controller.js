import { Controller } from '@hotwired/stimulus';

import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

export default class extends Controller {
  static targets = ['map'];

  connect() {
    mapboxgl.accessToken = this.mapTarget.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/nproto/ckm6ozdmh3n4317nwpwobg5d8'
    });

    const markers = JSON.parse(this.mapTarget.dataset.markers);



    map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    }));

    this.addMarkersToMap(map, markers);
    this.fitMapToMarkers(map, markers);

    // Fixes center moving on refresh
    window.addEventListener('load', () => {
      map.resize();
      this.fitMapToMarkers(map, markers);
    })
  }

  customMarker(marker) {
    // Create a HTML element for your custom marker
    const element = document.createElement('div');
    element.className = 'marker';
    element.style.backgroundImage = `url('${marker.image_url}')`;
    element.style.backgroundSize = 'contain';
    element.style.width = '25px';
    element.style.height = '25px';

    return element;
  }

  addMarkersToMap(map, markers) {
    markers.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window);

      const element = this.customMarker(marker);

      new mapboxgl.Marker(element)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(map);
    });
  }

  fitMapToMarkers(map, markers) {
    const bounds = new mapboxgl.LngLatBounds();

    markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
    map.fitBounds(bounds, {
      padding: 100,
      maxZoom: 15,
      duration: 0
    });
  };

}