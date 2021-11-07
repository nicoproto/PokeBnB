import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['total', 'start', 'end', 'price', 'box'];

  connect() {
    this.startTarget.addEventListener('change', () => {
      const splittedDates = this.startTarget.value.split(" ");
      const startDate = Date.parse(splittedDates[0]);

      if (splittedDates.length >= 3) {
        const endDate = Date.parse(splittedDates[2]);
        this.updateTotal(startDate, endDate);
      }
    })
  }

  updateTotal(startDate, endDate) {
    const oneDay = 24 * 60 * 60 * 1000; // hours * minutes * seconds * milliseconds
    const diffDays = Math.round(Math.abs((endDate - startDate) / oneDay));
    const price = parseFloat(this.priceTarget.innerText);
    const totalPrice = diffDays * price;

    if (totalPrice <= 0) {
      this.totalTarget.innerText = " - ";
    } else {
      this.totalTarget.innerText = totalPrice;
      this.boxTarget.classList.add('active');
    }
  }
}