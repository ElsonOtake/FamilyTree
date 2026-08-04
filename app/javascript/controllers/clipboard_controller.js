import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
// Copies the full secret (data-clipboard-text-value) to the clipboard while the
// page only ever displays a masked version. The button (data-clipboard-target="button")
// briefly swaps to a confirmation label (data-clipboard-copied-value) on success.
export default class extends Controller {
  static targets = ["button"]
  static values = { text: String, copied: String }

  copy() {
    this.write(this.textValue).then((ok) => ok && this.confirm())
  }

  // Prefer the async Clipboard API; fall back to a hidden textarea + execCommand
  // for older or non-secure contexts.
  async write(text) {
    try {
      if (navigator.clipboard?.writeText) {
        await navigator.clipboard.writeText(text)
        return true
      }
    } catch {
      // fall through to the legacy path
    }

    const textarea = document.createElement("textarea")
    textarea.value = text
    textarea.setAttribute("readonly", "")
    textarea.style.position = "absolute"
    textarea.style.left = "-9999px"
    document.body.appendChild(textarea)
    textarea.select()
    let ok = false
    try {
      ok = document.execCommand("copy")
    } catch {
      ok = false
    }
    document.body.removeChild(textarea)
    return ok
  }

  confirm() {
    if (!this.hasButtonTarget) return

    const button = this.buttonTarget
    const original = button.textContent
    button.textContent = this.copiedValue
    button.disabled = true
    setTimeout(() => {
      button.textContent = original
      button.disabled = false
    }, 2000)
  }
}
