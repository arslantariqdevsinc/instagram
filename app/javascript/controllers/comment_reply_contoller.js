import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  toggle(e){
    e.preventDefault()
    console.log("toggle")
    this.formTarget.classList.toggle("d-none")

  }
}
