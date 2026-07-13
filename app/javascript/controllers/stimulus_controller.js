import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stimulus"
// Modal open/close (Tailwind visibility) and the search autocomplete helpers.
// The navbar and flash have their own controllers.
export default class extends Controller {
  static values = { id: { type: String, default: "" } }

  initialize = () => {
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") this.closeAllModals()
    })
  }

  openModal = (el) => {
    el.classList.remove("hidden")
  }

  closeModal = (el) => {
    el.classList.add("hidden")
  }

  closeAllModals = () => {
    document.querySelectorAll(".modal").forEach(($modal) => this.closeModal($modal))
  }

  // Open/close a modal by its id (from the trigger's stimulus-id-value).
  open = () => {
    const target = document.getElementById(this.idValue)
    if (target != null) this.openModal(target)
  }

  close = () => {
    const target = document.getElementById(this.idValue)
    if (target != null) this.closeModal(target)
  }

  // Close the modal containing the clicked element (backdrop / close button).
  dismiss = (event) => {
    const modal = event.target.closest(".modal")
    if (modal != null) this.closeModal(modal)
  }

  submitEnd = (event) => {
    if (event.detail.success) this.closeAllModals()
  }

  select_child = ({ params }) => {
    const resultsList = document.getElementById("results-list")
    const childId = document.getElementById("child_id")
    const name = document.getElementById("name")
    const qNameCont = document.getElementById("q_name_cont")
    const submitButton = document.getElementById("submit-button")
    qNameCont.value = ""
    name.value = params.name
    childId.value = params.childId
    submitButton.disabled = false
    resultsList.replaceChildren()
  }

  select_mate = ({ params }) => {
    const resultsList = document.getElementById("results-list")
    const personId = document.getElementById("couple_person2_id")
    const name = document.getElementById("couple_name")
    const qNameCont = document.getElementById("q_name_cont")
    const submitButton = document.getElementById("submit-button")
    qNameCont.value = ""
    name.value = params.name
    personId.value = params.personId
    submitButton.disabled = false
    resultsList.replaceChildren()
  }
}
