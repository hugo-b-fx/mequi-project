Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  # Sélecteur de login
  get "/login-selector", to: "users#login_selector"

  # Coaches (avec index pour la page listing)
  resources :coaches, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :availability
    end
  end

  # Disponibilités des coachs
  resources :coach_availabilities, only: [:create, :update, :destroy]

  # Bookings (création de réservation)
  resources :bookings, only: [:create]

  # Profils cavaliers (users)
  resources :users, only: [:show, :edit, :update] do
    member do
      get :dashboard # Tableau de bord personnel
    end
  end

  # Chevaux
  resources :horses, except: [:index, :show] do
    member do
      delete :remove_photo # Pour supprimer une photo spécifique
    end
  end
end
