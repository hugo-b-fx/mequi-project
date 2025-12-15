import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["box", "messages", "input"]

  toggle() {
    this.boxTarget.classList.toggle("d-none")
  }

  async send(event) {
    event.preventDefault()

    const message = this.inputTarget.value.trim()
    if (message === "") return

    this.inputTarget.value = ""

    // Message utilisateur
    this.messagesTarget.insertAdjacentHTML(
      "beforeend",
      `<div class="text-end mb-2"><strong>Vous :</strong> ${message}</div>`
    )

    try {
      const response = await fetch("/messages", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ content: message })
      })

      if (!response.ok) {
        throw new Error("Erreur serveur")
      }

      const html = await response.text()

      // Turbo Stream injecte directement la réponse
      this.messagesTarget.insertAdjacentHTML("beforeend", html)

      // Scroll auto
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight

    } catch (error) {
      this.messagesTarget.insertAdjacentHTML(
        "beforeend",
        `<div class="mb-2 text-danger"><strong>Assistant :</strong> Oups 😅 une erreur est survenue.</div>`
      )
    }
  }
}
