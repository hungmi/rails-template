// 搭配 partial _image_field, _image_field 使用

import { Controller } from "stimulus"

export default class extends Controller {
	static targets = [ "fileInput", "oldImage", "previewer" ]

	connect() {
    	console.log('Hello, Stimulus!')
  	}

  	get imagePreviewContainerWrapperClass() {
  		return ""
  	}

  	get imagePreviewContainer() {
  		return `
			<img src="" style="max-width: 100%; width: 200px;">
			<small class="img-file-title"></small>`
  	}

  	videoPreviewContainerWrapperClass() {
  		return "card"
  	}

  	videoPreviewContainer() {
  		return `
			<video controls class="card-img-top" src=""></video>
			<div class="card-body px-0 text-center">
				<h5 class="card-title"></h5>
			</div>`
	}

	showPreview(e) {
	  	if (this.fileInputTarget.files !== undefined) {
			let previewer = this.previewerTarget
			previewer.innerHTML = ''
			for (let i = 0; i < this.fileInputTarget.files.length; i++) {
				var appended = document.createElement('div')
				// console.log(this.fileInputTarget.files[i])

				if (this.fileInputTarget.files[i].type.includes("video")) {
					appended.className += this.videoPreviewContainerWrapperClass
					appended.innerHTML = this.videoPreviewContainer
				} else if (this.fileInputTarget.files[i].type.includes("image")) {
					appended.className += this.imagePreviewContainerWrapperClass
					appended.innerHTML = this.imagePreviewContainer
				} else {
					appended.className += this.imagePreviewContainerWrapperClass
					appended.innerHTML = this.imagePreviewContainer
				}


				previewer.appendChild(appended)
				let targetMedia = previewer.querySelectorAll("video, img")[i]
				if (targetMedia !== undefined) {
					this.previewFile(targetMedia, this.fileInputTarget.files[i], e.target)
					targetMedia.parentNode.querySelector(".img-file-title").innerHTML = this.fileInputTarget.files[i].name
				}
			}
			if (this.hasOldImageTarget) {
				this.oldImageTarget.style.opacity = 0.3 // 單張圖的情況下，上傳即覆蓋，因此將其透明化
			}
		}
  	}

  	previewFile(previewer, file, fileInput) {
  		var controller = this
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
					controller.fileDimensionValidator(reader.result, file, previewer, fileInput, expectWidth, expectHeight)
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

	fileDimensionValidator(result, file, previewer, fileInput, expectWidth, expectHeight) {
		var controller = this
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
		      		var expectRatio = parseFloat(expectWidth) / parseFloat(expectHeight)
		      		var stretchedWidth = height * expectRatio
		      		if (stretchedWidth >= width && stretchedWidth <= width * 1.01) {
						console.log("<= 1.01")
		      			valid = valid && true
		      		} else if (stretchedWidth <= width && stretchedWidth >= width * 0.99) {
		      			valid = valid && true
		      		} else {
						console.log("invalid!")
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
					controller.previewerTarget.innerHTML = ""
					controller.fileInputTarget.value = ""
				}
			}
		} else if (file.type.includes("image")) {
			var tempLoader = document.createElement("img");
			tempLoader.src = result
			tempLoader.onload = function () {
				width = tempLoader.width
				height = tempLoader.height
				if (expectWidth !== null && expectHeight !== null) {
					var expectRatio = parseFloat(expectWidth) / parseFloat(expectHeight)
					var stretchedWidth = height * expectRatio
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
					console.log(valid)
				} else {
					alert(`${file.name}尺寸為${width}x${height}，不符合指定尺寸`)
					controller.previewerTarget.innerHTML = ""
					controller.fileInputTarget.value = ""
				}
			}
		}
	}
}