import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = [ "textArea", "fileField" ]

  clear() {
    this.textAreaTarget.value = ""
    this.fileFieldTarget.value = ""
  }

  preventEmpty(event) {
    if (this.textAreaTarget.value === "" && this.fileFieldTarget.value === "") {
      event.preventDefault()
    } 
    else {
      return
    }
  }
}
