import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "button", "label"]

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  connect() {
    this.handleClickOutside = (e) => {
      if (!this.element.contains(e.target)) {
        this.dropdownTarget.classList.add("hidden")
      }
    }
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }
}
