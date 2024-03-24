import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stimulus"
export default class extends Controller {
  static values = { id: { type: String, default: "" } };

  burger = () => {
    const burger = document.querySelector(".navbar-burger");
    const nav = document.querySelector("#"+burger.dataset.target);
    burger.classList.toggle("is-active");
    nav.classList.toggle("is-active");
  }

  openModal = (el) => {
    el.classList.add('is-active');
  }
  
  closeModal = (el) => {
    el.classList.remove('is-active');
  }
  
  closeAllModals = () => {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      this.closeModal($modal);
    });
  }

  initialize = () => {
    const close_option = document.querySelectorAll('.modal-background, .modal-close');
    (close_option || []).forEach((close) => {
      const target = close.closest('.modal');
      close.addEventListener('click', () => {
        this.closeModal(target);
      });
    });

    document.addEventListener('keydown', (event) => {
      if (event.key == "Escape") {
        this.closeAllModals();
      }
    });
  }

  open = () => {
    const target = document.getElementById(this.idValue);
    if (target != null) {
      this.openModal(target);
    }
  }
  
  close = () => {
    const target = document.getElementById(this.idValue);
    if (target != null) {
      this.closeModal(target);
    }
  }

  submitEnd = (event) => {
    if (event.detail.success) {
      this.closeAllModals();
    }
  }
  
  closeNotification = () => {
    const notification = document.querySelectorAll("#flash div");
    notification[0].parentNode.removeChild(notification[0]);
  }

  select_child = () => {
    const resultsList = document.getElementById("results-list");
    const childId = document.getElementById("child_id");
    const name = document.getElementById("name");
    const qNameCont = document.getElementById("q_name_cont");
    const submitButton = document.getElementById("submit-button");
    qNameCont.value = "";
    name.value = this.element.innerText;
    childId.value = this.element.className.split('_')[1];
    submitButton.disabled = false;
    resultsList.replaceChildren();
  }

  select_mate = () => {
    const resultsList = document.getElementById("results-list");
    const personId = document.getElementById("couple_person2_id");
    const name = document.getElementById("couple_name");
    const qNameCont = document.getElementById("q_name_cont");
    const submitButton = document.getElementById("submit-button");
    qNameCont.value = "";
    name.value = this.element.innerText;
    personId.value = this.element.className.split('_')[1];
    submitButton.disabled = false;
    resultsList.replaceChildren();
  }
}
