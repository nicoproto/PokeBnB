import { Controller } from '@hotwired/stimulus';

import Swal from 'sweetalert2';
import 'sweetalert2/src/sweetalert2.scss';

export default class extends Controller {
  trigger(event) {
    const hiddenBtn = event.currentTarget.nextElementSibling;

    Swal.fire({
      title: this.element.dataset.title || 'Title',
      text: this.element.dataset.text || 'Text',
      icon: this.element.dataset.icon || 'warning',
      confirmButtonText: this.element.dataset.button || 'Yes',
      showCancelButton: this.element.dataset.cancel == 'true' || false,
    }).then((result) => {
      if (result.isConfirmed) {
        hiddenBtn.click();
      }
    })
  }
}