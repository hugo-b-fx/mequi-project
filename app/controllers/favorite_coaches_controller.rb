class FavoriteCoachesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coach

  def create
    @favorite = current_user.favorite_coaches.build(coach: @coach)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_back fallback_location: coach_path(@coach), notice: "Coach ajouté à vos favoris" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("favorite-btn-#{@coach.id}", partial: "favorite_coaches/button", locals: { coach: @coach }) }
        format.json { render json: { status: "added", coach_id: @coach.id } }
      else
        format.html { redirect_back fallback_location: coach_path(@coach), alert: @favorite.errors.full_messages.join(", ") }
        format.json { render json: { status: "error", errors: @favorite.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @favorite = current_user.favorite_coaches.find_by(coach: @coach)

    respond_to do |format|
      if @favorite&.destroy
        format.html { redirect_back fallback_location: coach_path(@coach), notice: "Coach retiré de vos favoris" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("favorite-btn-#{@coach.id}", partial: "favorite_coaches/button", locals: { coach: @coach }) }
        format.json { render json: { status: "removed", coach_id: @coach.id } }
      else
        format.html { redirect_back fallback_location: coach_path(@coach), alert: "Erreur lors de la suppression" }
        format.json { render json: { status: "error" }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:coach_id])
  end
end
