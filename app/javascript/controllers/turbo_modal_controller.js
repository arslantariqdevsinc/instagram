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

  submitEnd(e) {
    if (e.detail.success) {
      var myModal = document.getElementById("myModal");
      var modal = bootstrap.Modal.getInstance(myModal)
      modal.hide();
      document.body.classList.remove("modal-open");
      document.getElementsByClassName("modal-backdrop")[0].remove();
      this.modal.hide();
    }
  }
}
