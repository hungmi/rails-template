// <div data-controller="nested-form">
//     <div data-nested-form-target="<%= 'draft' if f.object.draft %>">
//         // Use Resouce.build(draft: true) and render here
// 	   </div>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["draft"]
	static values = {
		resourceName: String,
	}

	connect() {
		if (this.hasDraftTarget) {
			this.formHTML = this.draftTarget.outerHTML
			this.draftTarget.remove()
		}
	}

	add(e) {
		var epoch = Date.now()
		// 雙層 nested-form 請記得加上 data-nested-form-resource-name-value
		// <div data-controller="nested-form">
		// 	<div data-controller="nested-form" data-nested-form-resource-name-value="model_name_in_plural"></div>
		// </div>
		if (this.hasResourceNameValue) {
			const regex1 = new RegExp(`${this.resourceNameValue}_attributes_\\d+_`, 'g')
			const regex2 = new RegExp(`${this.resourceNameValue}_attributes\\]\\[\\d+\\]`, 'g')
			var newForm = this.formHTML.replaceAll(regex1, `${this.resourceNameValue}_attributes_${epoch}_`).replaceAll(regex2, `${this.resourceNameValue}_attributes][${epoch}]`).replace('hidden=""', '')
		} else {
			var newForm = this.formHTML.replaceAll(/_\d+_/g, `_${epoch}_`).replaceAll(/\[\d+\]/g, `[${epoch}]`).replace('hidden=""', '')
		}
		e.target.insertAdjacentHTML('beforebegin', newForm)
	}
}