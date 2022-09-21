import { Controller } from "@hotwired/stimulus"
export default class extends Controller {

  connect() {
    this.modal = new bootstrap.Modal(this.element.firstElementChild, {keyboard: false})
    this.modal.show()
  }
  disconnect(){
      this.modal.hide();
  }

  hideModal(){
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }
}
