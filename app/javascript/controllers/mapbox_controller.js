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

    this.markersHover();
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


  tiltMarker(marker, rotation) {
    marker.style.transition = "all 0.5s ease"
    let string = marker.style.transform;
    let array = string.split(")");
    let new_string = array[0] + ") " + array[1] + ") " + `rotate(${rotation}deg)`;
    marker.style.transform = new_string;
  };

  renderTilt(collection, array, markers) {
    collection.forEach((instance) => {
      instance.addEventListener("mouseover", (event) => {
        const instance_index = array.indexOf(event.currentTarget);
        this.tiltMarker(markers[instance_index], 30);
        setTimeout(() => {
          this.tiltMarker(markers[instance_index], -30);
        }, 200);
        setTimeout(() => {
          this.tiltMarker(markers[instance_index], 0);
        }, 400);
        setTimeout(() => {
          this.tiltMarker(markers[instance_index], -30);
        }, 600);
        setTimeout(() => {
          this.tiltMarker(markers[instance_index], 0);
        }, 800);
      });
    });
  }

  markersHover() {
    const cards = document.querySelectorAll(".cards .card");
    const cards_array = Array.prototype.slice.call(cards);

    const markers = document.querySelectorAll(".marker");
    const markers_array = Array.prototype.slice.call(markers);

    this.renderTilt(cards, cards_array, markers);
    this.renderTilt(markers, markers_array, markers);
  }

}