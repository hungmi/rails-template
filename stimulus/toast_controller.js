import { Controller } from "stimulus"

export default class extends Controller {
	static targets = []

	connect() {
		console.log('toasting')
		var toast = new bootstrap.Toast(this.element)
		toast.show()
	}
}