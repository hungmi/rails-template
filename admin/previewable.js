// 參考用法
// <div id="newVideoCoverPreview"></div>
// <%= f.file_field :cover, class: "form-control previewable", data: { previewer: "newVideoCoverPreview" } %>

var imagePreviewContainerWrapperClass = ""
var imagePreviewContainer = `
	<img src="" style="max-width: 100%; width: 200px;">
	<small class="img-file-title"></small>`

var videoPreviewContainerWrapperClass = "card"
var videoPreviewContainer = `
	<video controls class="card-img-top" src=""></video>
	<div class="card-body px-0 text-center">
		<h5 class="card-title"></h5>
	</div>`

$(document).on("change", "input[type='file'].previewable", function (e) {
	if (this.files !== undefined) {
		let previewerID = e.target.getAttribute("data-previewer")
		let previewer = document.getElementById(previewerID)
		previewer.innerHTML = ''
		for (let i = 0; i < this.files.length; i++) {
			var appended = document.createElement('div')
			// console.log(this.files[i])

			if (this.files[i].type.includes("video")) {
				appended.className += videoPreviewContainerWrapperClass
				appended.innerHTML = videoPreviewContainer
			} else if (this.files[i].type.includes("image")) {
				appended.className += imagePreviewContainerWrapperClass
				appended.innerHTML = imagePreviewContainer
			} else {
				appended.className += imagePreviewContainerWrapperClass
				appended.innerHTML = imagePreviewContainer
			}


			previewer.appendChild(appended)
			let targetMedia = previewer.querySelectorAll("video, img")[i]
			if (targetMedia !== undefined) {
				previewFile(targetMedia, this.files[i], e.target)
				targetMedia.parentNode.querySelector(".img-file-title").innerHTML = this.files[i].name
			}
		}
		if (e.target.parentNode.querySelector(".js-old-photo")) {
			e.target.parentNode.querySelector(".js-old-photo").style.opacity = 0.3
		}
	}
})

function previewFile(previewer, file, fileInput) {
	// var file    = file_input.files[0]; //sames as here
	var reader = new FileReader();

	reader.onloadend = function () {
		previewer.src = reader.result;
		let expectWidth = fileInput.getAttribute("data-expectWidth")
		let expectHeight = fileInput.getAttribute("data-expectHeight")
		let expectImage = fileInput.getAttribute("data-expectImage")
		let expectVideo = fileInput.getAttribute("data-expectVideo")
		if (expectVideo == "false" && file.type.includes("video")) {
			// console.log("not validating video")
		} else if (expectImage == "false" && file.type.includes("image")) {
			// console.log("not validating image")
		} else {
			if (expectWidth !== null || expectHeight !== null) {
				fileDimensionValidator(reader.result, file, previewer, fileInput, expectWidth, expectHeight)
			}
		}
		// console.log(reader)
	}

	if (file) {
		reader.readAsDataURL(file); //reads the data as a URL
	} else {
		// previewer.src = "";
	}
}

function fileDimensionValidator(result, file, previewer, fileInput, expectWidth, expectHeight) {
	var width
	var height
	var valid = true
	// console.log(fileInput.getAttribute("data-expectWidth"))
	// console.log(parseInt(fileInput.getAttribute("data-expectHeight")))
	if (file.type.includes("video")) {
		var tempLoader = document.createElement("video");
		tempLoader.src = result
		tempLoader.onloadedmetadata = function() {
      width = tempLoader.videoWidth
      height = tempLoader.videoHeight
      if (expectWidth !== null && expectHeight !== null) {
      	expectRatio = parseFloat(expectWidth) / parseFloat(expectHeight)
      	stretchedWidth = height * expectRatio
      	if (stretchedWidth >= width && stretchedWidth <= width * 1.01) {
					// console.log("<= 1.01")
      		valid = valid && true
      	} else if (stretchedWidth <= width && stretchedWidth >= width * 0.99) {
      		valid = valid && true
      	} else {
					// console.log("invalid!")
      		valid = valid && false
      	}
      } else if (expectWidth !== null) {
      	valid = valid && (width >= parseInt(expectWidth))
      } else if (expectHeight !== null) {
      	valid = valid && (height >= parseInt(expectHeight))
      }
			// window.aaa = fileInput
			if (valid) {
			} else {
				alert(`${file.name}尺寸為${width}x${height}，不符合指定尺寸`)
				document.getElementById(fileInput.getAttribute("data-previewer")).innerHTML = ""
				fileInput.value = ""
				fileInput.parentNode.querySelector("label.custom-file-label").innerHTML = ""
			}
		}
	} else if (file.type.includes("image")) {
		var tempLoader = document.createElement("img");
		tempLoader.src = result
		tempLoader.onload = function () {
			width = tempLoader.width
			height = tempLoader.height
			if (expectWidth !== null && expectHeight !== null) {
				expectRatio = parseFloat(expectWidth) / parseFloat(expectHeight)
				stretchedWidth = height * expectRatio
				if (stretchedWidth >= width && stretchedWidth <= width * 1.01) {
					valid = valid && true
				} else if (stretchedWidth <= width && stretchedWidth >= width * 0.99) {
					valid = valid && true
				} else {
					valid = valid && false
				}
			} else if (expectWidth !== null) {
				valid = valid && (width >= parseInt(expectWidth))
			} else if (expectHeight !== null) {
				valid = valid && (height >= parseInt(expectHeight))
			}
			// window.aaa = fileInput
			if (valid) {
			} else {
				alert(`${file.name}尺寸為${width}x${height}，不符合指定尺寸`)
				document.getElementById(fileInput.getAttribute("data-previewer")).innerHTML = ""
				fileInput.value = ""
				fileInput.parentNode.querySelector("label.custom-file-label").innerHTML = ""
			}
		}
	}
}