import { Controller } from "@hotwired/stimulus"
import * as bootstrap from 'bootstrap'

// Connects to data-controller="toast"
export default class extends Controller {
  	static targets = ["toast"]

  	connect() {
    	console.log('toast connected')
  	}

  	toastTargetConnected(toast) {
    	var toastBootstrapInstance = new bootstrap.Toast(toast)
    	toastBootstrapInstance.show()
    	toast.addEventListener("hidden.bs.toast", () => {
      		toast.remove()
    	})
  	}
}