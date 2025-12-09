Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#index"

  get "/login-selector", to: "users#login_selector"
  post "/search", to: "home#search"


# Routes pour les profils de coachs
  resources :coaches, only: [:show, :new, :create, :edit, :update] do
    member do
      get :availability # Pour afficher les disponibilités en détail
    end
  end

  # Routes pour les disponibilités des coachs
  resources :coach_availabilities, only: [:create, :update, :destroy]


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
