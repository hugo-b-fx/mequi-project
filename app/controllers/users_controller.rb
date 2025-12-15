class UsersController < ApplicationController
  def login_selector
  end

  before_action :authenticate_user!, except: [:show]
  before_action :set_user, only: [:show, :edit, :update, :dashboard]
  before_action :authorize_user, only: [:edit, :update, :dashboard]

  # GET /users/:id - Profil PUBLIC du cavalier
  def show
    @horses = @user.horses.order(created_at: :desc)
    @completed_bookings = @user.completed_bookings.limit(6)
    @total_lessons = @user.total_lessons
    @total_hours = @user.total_hours_trained
    @reviews_given = @user.reviews.order(created_at: :desc).limit(3)
  end

  # GET /users/:id/edit - Formulaire d'édition du profil
  def edit
    3.times { @user.horses.build } if @user.horses.empty?
  end

  # PATCH/PUT /users/:id - Mise à jour du profil
  def update
    if @user.update(user_params)
      redirect_to dashboard_user_path(@user), notice: "Profil mis à jour !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /users/:id/dashboard - Tableau de bord personnel
  def dashboard
    @horses = @user.horses.includes(:bookings).order(created_at: :desc)

    # Préparer les prochaines sessions par cheval
    @horses_with_sessions = @horses.map do |horse|
      upcoming = horse.bookings
                      .where("start_at > ?", Time.current)
                      .where(status: ["pending", "confirmed"])
                      .order(start_at: :asc)
                      .limit(3)
                      .includes(coach: :user)
      {
        horse: horse,
        upcoming_sessions: upcoming
      }
    end

    # Agenda global
    @upcoming_bookings = @user.upcoming_bookings
                              .includes(:horse, coach: :user)
                              .order(start_at: :asc)
                              .limit(10)

    @past_bookings = @user.completed_bookings
                          .includes(:horse, coach: :user)
                          .order(start_at: :desc)
                          .limit(8)

    # Coachs favoris (wishlist)
    @favorite_coaches = @user.favorited_coaches.includes(:user).limit(6)

    # Coachs contactés (via bookings)
    @contacted_coaches = @user.contacted_coaches.limit(6)

    # Stats
    @stats = {
      total_lessons: @user.total_lessons,
      total_hours: @user.total_hours_trained.round,
      horses_count: @horses.count,
      coaches_count: @user.booked_coaches.distinct.count,
      favorites_count: @user.favorite_coaches.count
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    unless current_user == @user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page"
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone,
      :bio,
      :photo,
      horses_attributes: [
        :id,
        :name,
        :age,
        :breed,
        :discipline,
        :_destroy,
        photos: []
      ]
    )
  end
end
