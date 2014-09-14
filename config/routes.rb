Mashin::Application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users' }
  devise_scope :user do
    resources :users, only: [:show]
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end

  resources :searches, only: [:show, :create, :index] do
    collection do
      post "ajax"
    end
  end

  resources :preferences, only: [:create, :destroy] do
    post "range_filters", on: :collection
    post "non_model_filters", on: :collection
  end

  resources :ads do
    resources :images
    collection do
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
      get "unverified_ads"
      get "topics"
      get "subtopics"
      get "car_models"
      get 'scrap_car_info_car_models'
    end
  end

  resources :scraps, only: [:index] 
  resources :scrap_articles, only: [:index] 

  resource  :homes, only: [:show]
  resource  :dashboard, only: [:show]
  resources :locations
  resources :body_colors
  resources :internal_colors
  resources :makes do
    get 'scrap', on: :collection
    resources :car_models do
      # get 'scrap_car_info', on: :collection
      resources :built_years
    end
  end


  resources :subtopics
  resources :topics do
    resources :articles
  end

  get "car_infos" => 'scrap_car_infos#index'
  # get '' => 'topics#index', constraints: lambda { |r| r.subdomain.present? and r.subdomain != "www" and r.subdomain=="home"}
  # get '' => 'topics#show',  constraints: lambda { |r| r.subdomain.present? and r.subdomain != "www" }

  root 'homes#show'
end
