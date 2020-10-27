// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'bootstrap/dist/js/bootstrap'

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("trix")
require("@rails/actiontext")
var tablesort = require('tablesort')
import "../packs/sortable.js"
import "controllers"

window.addEventListener("load", () => {
	if ( document.body.classList.contains('admin-users-index') ) {
		tablesort(document.querySelector("#js-users-tablesort"), { descending: true })
	}
})