// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start()

import "controllers"

require("trix")
require("@rails/actiontext")

import "../packs/sortable.js"

import '../stylesheets/admin.sass'
import 'flatpickr/dist/flatpickr.css'
import 'flatpickr/dist/themes/dark.css'

document.addEventListener("turbo:load", () => {
	console.log('turboing')
})