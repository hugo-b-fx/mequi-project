import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal",
    "step",
    "progressStep",
    "nextBtn",
    "startAt",
    "endAt",
    "slotPreview",
    "recapHorse",
    "recapSlot"
  ]

  connect() {
    this.currentStep = 0
    this.updateProgress()
  }

  /* =====================
     MODAL
     ===================== */

  open() {
    this.modalTarget.classList.remove("d-none")
  }

  close() {
    this.modalTarget.classList.add("d-none")
  }

  /* =====================
     NAVIGATION STEPS
     ===================== */

  next() {
    if (this.currentStep >= this.stepTargets.length - 1) return
    this.animateStep("forward")
  }

  prev() {
    if (this.currentStep <= 0) return
    this.animateStep("backward")
  }

  animateStep(direction) {
    const current = this.stepTargets[this.currentStep]
    const nextIndex =
      direction === "forward"
        ? this.currentStep + 1
        : this.currentStep - 1

    const next = this.stepTargets[nextIndex]

    // sortie step courant
    current.classList.remove("active")
    current.classList.add(direction === "forward" ? "exit-left" : "exit-right")

    // entrée step suivant
    next.classList.remove("exit-left", "exit-right")
    next.classList.add("active")

    // cleanup anim
    setTimeout(() => {
      current.classList.remove("exit-left", "exit-right")
    }, 300)

    this.currentStep = nextIndex
    this.updateProgress()
    this.updateRecap()
  }

  /* =====================
     DATA SELECTION
     ===================== */

  selectHorse(event) {
    this.nextBtnTargets[0].disabled = !event.target.value
  }

  pickSlot(event) {
    const btn = event.currentTarget

    this.startAtTarget.value = btn.dataset.startAt
    this.endAtTarget.value = btn.dataset.endAt
    this.slotPreviewTarget.textContent = btn.dataset.label

    // bouton "Continuer" du step 2
    this.nextBtnTargets[1].disabled = false

    this.updateRecap()
  }

  /* =====================
     UI UPDATES
     ===================== */

  updateRecap() {
    const horseSelect = this.element.querySelector("select[name='horse_id']")

    this.recapHorseTarget.textContent =
      horseSelect?.selectedOptions?.[0]?.textContent || "—"

    this.recapSlotTarget.textContent =
      this.slotPreviewTarget.textContent || "—"
  }

  updateProgress() {
    this.progressStepTargets.forEach((el, index) => {
      el.classList.toggle("active", index === this.currentStep)
    })
  }
}
