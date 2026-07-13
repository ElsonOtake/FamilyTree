import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="favorites"
// Toggles a person's favorite state via fetch (JSON) without a full navigation,
// then swaps the button's Tailwind classes and its form action/method in place.
export default class extends Controller {
  static FAVORITED = "btn btn-sm btn-danger"
  static UNFAVORITED = "btn btn-sm btn-secondary"

  toggle = async (event) => {
    event.preventDefault()
    const form = event.target.closest("form")
    if (!form) return
    const button = form.querySelector("button")
    button.disabled = true

    try {
      const response = await fetch(form.action, {
        method: form.method,
        headers: { Accept: "application/json", "X-CSRF-Token": this.csrfToken() },
        body: new FormData(form)
      })
      const result = await response.json()
      if (!response.ok) return

      if (result.status === "favorited") {
        button.className = this.constructor.FAVORITED
        button.title = button.dataset.removeTitle || button.title
        form.action = form.action.replace(/\/favorites(\/\d+)?$/, `/favorites/${result.id}`)
        this.setMethod(form, "delete")
      } else if (result.status === "unfavorited") {
        button.className = this.constructor.UNFAVORITED
        button.title = button.dataset.addTitle || button.title
        form.action = form.action.replace(/\/favorites\/\d+$/, "/favorites")
        this.setMethod(form, null)
      }
    } catch (error) {
      // Leave the button unchanged on network error; server-side flash covers it.
    } finally {
      button.disabled = false
    }
  }

  setMethod(form, method) {
    let input = form.querySelector('input[name="_method"]')
    if (method) {
      if (!input) {
        input = document.createElement("input")
        input.type = "hidden"
        input.name = "_method"
        form.appendChild(input)
      }
      input.value = method
    } else if (input) {
      input.remove()
    }
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
