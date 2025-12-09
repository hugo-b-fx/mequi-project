class CoachesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_coach, only: [:show, :edit, :update]
  before_action :authorize_coach, only: [:edit, :update]

  # GET /coaches/:id - Page de profil PUBLIC
  def show
    @reviews = @coach.reviews.order(created_at: :desc).limit(2)
    @all_reviews_count = @coach.reviews.count
    @horses = @coach.user.horses
    @availabilities = @coach.coach_availabilities.order(:start_time)
  end

  # GET /coaches/new - Formulaire de création
  def new
    redirect_to root_path, alert: "Vous devez être connecté" unless user_signed_in?

    if current_user.coach.present?
      redirect_to edit_coach_path(current_user.coach), notice: "Vous avez déjà un profil coach"
    else
      @coach = Coach.new
      3.times { @coach.coach_availabilities.build } # Pour le formulaire
    end
  end

  # POST /coaches - Création du profil
  def create
    @coach = current_user.build_coach(coach_params)

    if @coach.save
      redirect_to coach_path(@coach), notice: "Votre profil coach a été créé avec succès ! Il sera examiné sous 48h."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /coaches/:id/edit - Formulaire d'édition
  def edit
    3.times { @coach.coach_availabilities.build } if @coach.coach_availabilities.empty?
  end

  # PATCH/PUT /coaches/:id - Mise à jour
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

  def coach_params
    params.require(:coach).permit(
      :price_per_hour,
      :years_experience,
      :location,
      :latitude,
      :longitude,
      :bio,
      :achievements,
      :main_diploma,
      :other_certifications,
      specialities: [],
      levels: [],
      coach_availabilities_attributes: [
        :id,
        :start_time,
        :end_time,
        :_destroy,
        days_off: []
      ]
    )
  end
end
