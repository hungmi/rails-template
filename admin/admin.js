// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "./sortable.js"

document.addEventListener("turbo:load", () => {
	console.log('turbo!')
})