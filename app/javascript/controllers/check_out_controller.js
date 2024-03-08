import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="check-out"
export default class extends Controller {
  static targets = ['backGround','checkBox'];
  
  change(event) {
    if (this.checkBoxTarget.checked === true && event.target === this.backGroundTarget) { 
      this.checkBoxTarget.checked = false
    }
  }
  
}