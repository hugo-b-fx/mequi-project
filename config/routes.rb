Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "/login-selector", to: "users#login_selector"

  resources :coaches, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :availability
    end
  end

  resources :coach_availabilities, only: [:create, :update, :destroy]
  resources :bookings, only: [:create]

  get "up" => "rails/health#show", as: :rails_health_check
end
