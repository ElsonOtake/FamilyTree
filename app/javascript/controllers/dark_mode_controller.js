import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  static targets = ["icon", "text"]

  connect() {
    // Load saved theme preference or default to light
    const savedTheme = localStorage.getItem('theme') || 'light'
    this.setTheme(savedTheme)
  }

  toggle() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light'
    const newTheme = currentTheme === 'light' ? 'dark' : 'light'
    this.setTheme(newTheme)
    localStorage.setItem('theme', newTheme)
  }

  setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme)
    this.updateToggleButton(theme)
  }

  updateToggleButton(theme) {
    if (this.hasIconTarget && this.hasTextTarget) {
      if (theme === 'dark') {
        this.iconTarget.className = 'icon'
        this.iconTarget.innerHTML = '<i class="fas fa-sun"></i>'
        this.textTarget.textContent = 'Light Mode'
      } else {
        this.iconTarget.className = 'icon'
        this.iconTarget.innerHTML = '<i class="fas fa-moon"></i>'
        this.textTarget.textContent = 'Dark Mode'
      }
    }
  }
}