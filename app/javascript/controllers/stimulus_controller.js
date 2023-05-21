import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stimulus"
export default class extends Controller {
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
}
