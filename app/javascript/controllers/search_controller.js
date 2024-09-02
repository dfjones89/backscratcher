import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  // connect() {
  //   console.log("Search controller connected")
  // }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 500)
  }

  handleKeyup(event) {
    if (event.key === "Escape") {
      this.inputTarget.value = ""
      this.element.requestSubmit()
    }
  }
}
