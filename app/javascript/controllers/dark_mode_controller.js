import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  static targets = ["icon", "text"]

  connect() {
    console.log('Dark mode controller connected!')
    // Load saved theme preference or default to light
    const savedTheme = localStorage.getItem('theme') || 'light'
    console.log('Loaded theme:', savedTheme)
    this.setTheme(savedTheme)
  }

  toggle() {
    console.log('Toggle clicked!')
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light'
    const newTheme = currentTheme === 'light' ? 'dark' : 'light'
    console.log('Switching from', currentTheme, 'to', newTheme)
    this.setTheme(newTheme)
    localStorage.setItem('theme', newTheme)
  }

  setTheme(theme) {
    console.log('Setting theme to:', theme)
    document.documentElement.setAttribute('data-theme', theme)
    console.log('HTML data-theme attribute set:', document.documentElement.getAttribute('data-theme'))
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