import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="source-toggle"
// Radios (data-action="source-toggle#select") carry a value; each panel
// (data-source-toggle-target="panel") carries data-source="<value>". Selecting a
// radio shows the matching panel and hides the others.
export default class extends Controller {
  static targets = ["panel"]

  select(event) {
    const name = event.target.value

    this.panelTargets.forEach((panel) => {
      panel.classList.toggle("hidden", panel.dataset.source !== name)
    })
  }
}
