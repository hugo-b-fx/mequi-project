// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import BookingModalController from "./booking_modal_controller"
application.register("booking-modal", BookingModalController)
eagerLoadControllersFrom("controllers", application)
