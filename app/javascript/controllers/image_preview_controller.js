import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['input', 'preview'];

  connect() {
    this.inputTarget.addEventListener('change', () => this.displayPreview());
  }

  displayPreview() {
    if (this.inputTarget.files && this.inputTarget.files[0]) {
      const reader = new FileReader();
      reader.onload = (event) => {
        this.previewTarget.src = event.currentTarget.result;
      }
      reader.readAsDataURL(this.inputTarget.files[0])
      this.previewTarget.classList.remove('hidden');
    }
  }
}
