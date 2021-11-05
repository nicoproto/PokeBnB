import { Controller } from '@hotwired/stimulus';

import flatpickr from "flatpickr";
import rangePlugin from "flatpickr/dist/plugins/rangePlugin";

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      altInput: true,
        plugins: [new rangePlugin({
          input: "#booking_end_date"
        })]
    });
  }
}
