import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"

export default class extends Controller {
  static targets = [ "output", "input","test" ]

  connect(){
    console.log("connected")
  }
  Test(e){
    console.log("Testing")
  }

  readURL() {
    var input = this.inputTarget
    var output = this.outputTarget


    function readAndPreview(file) {

      // Make sure `file.name` matches our extensions criteria
      if (/\.(jpe?g|png|gif)$/i.test(file.name)) {
        const reader = new FileReader();

        reader.addEventListener("load", () => {
          const image = new Image();
          image.height = 100;
          image.title = file.name;
          image.src = reader.result;
          image.classList.add("d-block", "w-100", "h-100", "img-fluid");
          // imageInfo = document.createElement("div");
          // image.appendChild()

          var carouselItem = document.createElement("div");
          carouselItem.classList.add("carousel-item");
          if(output.childElementCount == 0){
            carouselItem.classList.add("active");
          }
          carouselItem.appendChild(image)
          output.appendChild(carouselItem);
        }, false);

        reader.readAsDataURL(file);
      }
    }


   if (input.files) {

    Array.prototype.forEach.call(input.files, readAndPreview);
    }
 }

}
