import { Controller } from "@hotwired/stimulus"
import Cropper from "cropperjs"

// Connects to data-controller="avatar-cropper"
//
// Lets the user pick a region (e.g. one person out of a group photo) as the
// avatar. When a photo is chosen the cropper opens with a draggable, resizable
// portrait (3:4) selection box; applying it crops in the browser and writes the
// result back into the file input, so the normal form submit uploads just the
// cropped avatar — no backend changes. The original photo is not kept.
export default class extends Controller {
  static targets = ["input", "editor", "image", "preview"]
  static values = { aspect: { type: Number, default: 3 / 4 } }

  // A new file was chosen on the input: open the cropper on it.
  open() {
    const file = this.inputTarget.files[0]
    if (!file || !file.type.startsWith("image/")) return

    const reader = new FileReader()
    reader.onload = (event) => this.showEditor(event.target.result)
    reader.readAsDataURL(file)
  }

  showEditor(dataUrl) {
    this.destroyCropper()
    this.imageTarget.src = dataUrl
    this.editorTarget.classList.remove("hidden")
    this.cropper = new Cropper(this.imageTarget, {
      aspectRatio: this.aspectValue,
      viewMode: 1,
      autoCropArea: 0.6,
      background: false,
      movable: false,
      zoomable: false,
      rotatable: false,
    })
  }

  // Apply the selection: crop -> JPEG blob -> back into the file input.
  apply() {
    if (!this.cropper) return

    const canvas = this.cropper.getCroppedCanvas({
      maxWidth: 1000,
      maxHeight: 1400,
      imageSmoothingQuality: "high",
    })

    canvas.toBlob(
      (blob) => {
        if (!blob) return
        const file = new File([blob], "avatar.jpg", { type: "image/jpeg" })
        const data = new DataTransfer()
        data.items.add(file)
        this.inputTarget.files = data.files
        this.showPreview(canvas.toDataURL("image/jpeg"))
        this.closeEditor()
      },
      "image/jpeg",
      0.85,
    )
  }

  // Discard the selection and clear the chosen file.
  cancel() {
    this.inputTarget.value = ""
    this.closeEditor()
  }

  showPreview(url) {
    if (!this.hasPreviewTarget) return
    this.previewTarget.src = url
    this.previewTarget.classList.remove("hidden")
  }

  closeEditor() {
    this.destroyCropper()
    this.editorTarget.classList.add("hidden")
  }

  destroyCropper() {
    if (this.cropper) {
      this.cropper.destroy()
      this.cropper = null
    }
  }

  disconnect() {
    this.destroyCropper()
  }
}
