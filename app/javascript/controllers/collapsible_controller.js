import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body", "icon"]

  toggle() {
    this.bodyTarget.classList.toggle("hidden")
    this.iconTarget.classList.toggle("rotate-180")
  }
}
