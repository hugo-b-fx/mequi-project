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
    # Construire 3 chevaux vides pour le formulaire si aucun cheval
    3.times { @user.horses.build } if @user.horses.empty?
  end

  # PATCH/PUT /users/:id - Mise à jour du profil
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Votre profil a été mis à jour avec succès !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /users/:id/dashboard - Tableau de bord personnel (optionnel)
  def dashboard
    @upcoming_bookings = @user.upcoming_bookings.limit(5)
    @recent_bookings = @user.completed_bookings.limit(5)
    @horses = @user.horses
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
