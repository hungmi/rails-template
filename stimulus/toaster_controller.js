import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toaster"
export default class extends Controller {
    static targets = ["toastrack", "toast"]

    connect() {
        console.log('toaster connected')
    }

    toastTargetConnected(toast) {
        this.toastrackTarget.appendChild(toast)
    }
}
