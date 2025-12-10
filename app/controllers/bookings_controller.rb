class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @coach = Coach.find(params[:coach_id])
    @horse = current_user.horses.find(params[:horse_id])

    duration_hours = ((booking_params[:end_at].to_time - booking_params[:start_at].to_time) / 3600).round
    total_price = duration_hours * @coach.price_per_session

    @booking = Booking.new(
      coach: @coach,
      horse: @horse,
      start_at: booking_params[:start_at],
      end_at: booking_params[:end_at],
      total_price: total_price,
      status: "pending"
    )

    if @booking.save
      redirect_to coach_path(@coach), notice: "Votre cours a bien été réservé !"
    else
      redirect_to coach_path(@coach), alert: "Erreur lors de la réservation."
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_at, :end_at)
  end
end
