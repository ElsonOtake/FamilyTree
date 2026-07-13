import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
// Toggles Tailwind's class-based dark mode by adding/removing `dark` on <html>
// and persisting the choice. A pre-paint snippet in the <head> applies the
// stored theme before CSS loads to avoid a flash (FOUC).
export default class extends Controller {
  static targets = ["label"]

  connect() {
    this.updateLabel(document.documentElement.classList.contains("dark"))
  }

  toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    localStorage.setItem("theme", isDark ? "dark" : "light")
    this.updateLabel(isDark)
  }

  updateLabel(isDark) {
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = isDark ? "Light mode" : "Dark mode"
    }
  }
}
