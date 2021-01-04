import { Controller } from "stimulus"
import flatpickr from "flatpickr"
import "flatpickr/dist/l10n/zh-tw.js"

export default class extends Controller {
	static targets = [ "" ]

	connect() {
		this.initFlatpickrWithDataAttrs(this.element)
	}

	initFlatpickrWithDataAttrs(el) {
		var i18nLocale = el.getAttribute("data-flatpickr-locale") || "zh_tw"
		var mode = el.getAttribute("data-flatpickr-mode") || 'single'
		var minDate = el.getAttribute("data-flatpickr-min-date") || ''
		var maxDate = el.getAttribute("data-flatpickr-max-date") || ''
		var defaultDate = el.getAttribute("data-flatpickr-default-date") || ''
		flatpickr(el, {
			mode: mode,
			minDate: minDate,
			maxDate: maxDate,
			locale: i18nLocale,
			dateFormat: "Y-m-d",
			defaultDate: defaultDate,
		})
	}
}