import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  selectTab = () => {
    const tabs = document.querySelectorAll('.tabs li');
    const tabContentBoxes = document.querySelectorAll('#tab-content > div');
    
    tabs.forEach(function(tab) {
      tab.classList.remove('is-active');
    });
    this.element.classList.add('is-active');

    tabContentBoxes.forEach((box) => {
      if (box.getAttribute('id') === this.element.dataset.target) {
        box.classList.remove('is-hidden');
      } else {
        box.classList.add('is-hidden');
      }
    });
  };
}
