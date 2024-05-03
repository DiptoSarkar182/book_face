import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "input", "button" ]

    connect() {
        this.inputTarget.addEventListener('keydown', event => {
            if (event.keyCode === 13 && !event.shiftKey) {
                event.preventDefault();
                this.buttonTarget.click();
            }
        });
    }
}