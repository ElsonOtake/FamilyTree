import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stimulus"
export default class extends Controller {
  static values = { id: { type: String, default: "" } };

  burger() {
    const burger = document.querySelector(".navbar-burger");
    const nav = document.querySelector("#"+burger.dataset.target);
    burger.classList.toggle("is-active");
    nav.classList.toggle("is-active");
  }

  select() {
    const buttons = document.querySelectorAll(".first-letter-button");
    buttons.forEach(button => button.classList.remove("is-info"));
    this.element.classList.toggle("is-info");
  }

  openModal(el) {
    el.classList.add('is-active');
  }
  
  closeModal(el) {
    el.classList.remove('is-active');
  }
  
  closeAllModals() {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      this.closeModal($modal);
    });
  }

  initialize() {
    const close_option = document.querySelectorAll('.modal-background, .modal-close');
    (close_option || []).forEach((close) => {
      const target = close.closest('.modal');
      close.addEventListener('click', () => {
        this.closeModal(target);
      });
    });

    document.addEventListener('keydown', (event) => {
      const e = event || window.event;
      if (e.key == "Escape") { // Escape key
        this.closeAllModals();
      }
    });
  }

  open() {
    const target = document.getElementById(this.idValue);
    if (target != null) {
      this.openModal(target);
    }
  }
  
  close() {
    const target = document.getElementById(this.idValue);
    if (target != null) {
      this.closeModal(target);
    }
  }
  
  closeNotification() {
    const notification = document.querySelectorAll("#flash div");
    notification[0].parentNode.removeChild(notification[0]);  }
}
