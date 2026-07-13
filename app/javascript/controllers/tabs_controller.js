import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
// One controller wraps the tab buttons (data-tabs-target="tab" with
// data-tabs-panel-param="<name>") and the panels (data-tabs-target="panel"
// with data-tabs-panel="<name>"). Clicking a tab shows its panel.
export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const name = event.params.panel

    this.panelTargets.forEach((panel) => {
      panel.classList.toggle("hidden", panel.dataset.tabsPanel !== name)
    })

    this.tabTargets.forEach((tab) => {
      const active = tab.dataset.tabsPanelParam === name
      tab.classList.toggle("border-brand-500", active)
      tab.classList.toggle("text-brand-600", active)
      tab.classList.toggle("border-transparent", !active)
      tab.classList.toggle("text-slate-500", !active)
    })
  }
}
