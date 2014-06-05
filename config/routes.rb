Mashin::Application.routes.draw do


  root 'homes#show'

  devise_for :users, :controllers => { registrations: 'users' }
  devise_scope :user do
    resources :users, only: [:show]
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end

  resource  :homes, only: [:show]
  resource  :dashboard, only: [:show]
  resources :searches, only: [:show, :create, :index]
  resources :car_models
  resources :locations
  resources :body_colors
  resources :internal_colors
  resources :makes
  resources :preferences, only: [:create, :destroy] do
    post "range_filters", on: :collection
    post "non_model_filters", on: :collection
  end

  resources :ads do
    resources :images
    collection do
      get "unverifieds"
      get "verify"
    end
    member do
      get "touch"
      get "sold"
    end
  end

  resource  :admin, only: [:show] do
    collection do
      get "searches"
      get "users"
    end
  end

  resources :scraps, only: [:show, :index] do
    collection do
      post "scrap" 
    end
  end
end
