// document.addEventListener("DOMContentLoaded", function() {
// 	initializeSortable(document.getElementById("sortable__product-images"), ".sortable__input")
// })

function initializeSortable(target, inputSelector) {
	if (target !== null) {
		Sortable.create(target, {
			onSort: function (evt) {
				refreshOrdering(target, inputSelector)
			},
		});
	}
}

function refreshOrdering(list, inputSelector) {
	var inputs = list.querySelectorAll(inputSelector)
	console.log(inputs)
	var index = 0
	if (inputs !== null) {
		for (let input of inputs) {
			input.value = index + 1
			index += 1
		}	
	}	
}