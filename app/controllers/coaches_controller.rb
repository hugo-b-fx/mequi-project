class CoachesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_coach, only: [:show, :edit, :update]
  before_action :authorize_coach, only: [:edit, :update]

  def index
    @coaches = CoachSearchService.new(search_params).call.page(params[:page]).per(12)
    @specialities = Coach::SPECIALITIES
    @levels = Coach::LEVEL
  end

  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @slots = @coach.available_slots(@date)
    @reviews = @coach.reviews.includes(:user).order(created_at: :desc).limit(2)
    @all_reviews_count = @coach.reviews.count
    @horses = @coach.user.horses
    @availabilities = @coach.coach_availabilities.order(:start_time)
  end

  def new
    redirect_to root_path, alert: "Vous devez être connecté" unless user_signed_in?

    if current_user.coaches.exists?
      redirect_to edit_coach_path(current_user.coaches.first), notice: "Vous avez déjà un profil coach"
    else
      @coach = Coach.new
      3.times { @coach.coach_availabilities.build }
    end
  end

  def create
    @coach = current_user.coaches.build(coach_params)

    if @coach.save
      redirect_to coach_path(@coach), notice: "Votre profil coach a été créé avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    3.times { @coach.coach_availabilities.build } if @coach.coach_availabilities.empty?
  end

  def update
    if @coach.update(coach_params)
      redirect_to coach_path(@coach), notice: "Votre profil a été mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:id])
  end

  def authorize_coach
    unless current_user == @coach.user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à modifier ce profil"
    end
  end

  def search_params
    params.permit(:query, :location, :speciality, :level, :price_min, :price_max, :experience_min)
  end

  def coach_params
    params.require(:coach).permit(
      :price_per_session,
      :years_experience,
      :location,
      :latitude,
      :longitude,
      :level,
      :specialities,
      coach_availabilities_attributes: [
        :id,
        :start_time,
        :end_time,
        :_destroy,
        :days_off
      ]
    )
  end
end
