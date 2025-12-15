class HorsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_horse, only: [:edit, :update, :destroy, :remove_photo]
  before_action :authorize_horse_owner, only: [:edit, :update, :destroy, :remove_photo]

  # GET /horses/new
  def new
    @horse = current_user.horses.build
  end

  # POST /horses
  def create
    @horse = current_user.horses.build(horse_params)

    if @horse.save
      redirect_to dashboard_user_path(current_user), notice: "#{@horse.name} a été ajouté avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /horses/:id/edit
  def edit
  end

  # PATCH/PUT /horses/:id
  def update
    if @horse.update(horse_params)
      redirect_to dashboard_user_path(current_user), notice: "Les informations de #{@horse.name} ont été mises à jour"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /horses/:id
  def destroy
    horse_name = @horse.name
    @horse.destroy
    redirect_to dashboard_user_path(current_user), notice: "#{horse_name} a été supprimé"
  end

  # DELETE /horses/:id/remove_photo
  def remove_photo
    photo = @horse.photos.find(params[:photo_id])
    photo.purge
    redirect_to edit_horse_path(@horse), notice: "Photo supprimée"
  end

  private

  def set_horse
    @horse = Horse.find(params[:id])
  end

  def authorize_horse_owner
    unless @horse.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à modifier ce cheval"
    end
  end

  def horse_params
    params.require(:horse).permit(
      :name,
      :age,
      :breed,
      :discipline,
      photos: []
    )
  end
end
