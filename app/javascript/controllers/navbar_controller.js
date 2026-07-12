import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
// Handles the responsive mobile menu and click-to-toggle desktop dropdowns.
export default class extends Controller {
  static targets = ["menu", "panel"]

  connect() {
    this.onDocClick = (event) => {
      if (!this.element.contains(event.target)) this.closePanels()
    }
    this.onKeydown = (event) => {
      if (event.key === "Escape") {
        this.closePanels()
        this.closeMenu()
      }
    }
    document.addEventListener("click", this.onDocClick)
    document.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    document.removeEventListener("click", this.onDocClick)
    document.removeEventListener("keydown", this.onKeydown)
  }

  toggleMenu() {
    if (this.hasMenuTarget) this.menuTarget.classList.toggle("hidden")
  }

  closeMenu() {
    if (this.hasMenuTarget) this.menuTarget.classList.add("hidden")
  }

  toggle(event) {
    const panel = event.currentTarget.parentElement.querySelector("[data-navbar-target='panel']")
    if (!panel) return
    const willOpen = panel.classList.contains("hidden")
    this.closePanels()
    if (willOpen) panel.classList.remove("hidden")
  }

  closePanels() {
    this.panelTargets.forEach((panel) => panel.classList.add("hidden"))
  }
}
