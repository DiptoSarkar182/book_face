import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "menu" ]

    connect() {
        this.outsideClickListener = this.outsideClick.bind(this)
        document.addEventListener('click', this.outsideClickListener)
    }

    disconnect() {
        document.removeEventListener('click', this.outsideClickListener)
    }

    toggle(event) {
        event.preventDefault()
        event.stopPropagation()
        this.menuTarget.classList.toggle("hidden")
    }

    outsideClick(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add('hidden')
        }
    }
}