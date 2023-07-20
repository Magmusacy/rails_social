import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = [ "textArea" ]

  clear() {
    this.textAreaTarget.value = ""
  }

  preventEmpty(event) {
    if (this.textAreaTarget.value) {
      return
    } 
    else {
      event.preventDefault()
    }
  }
}
