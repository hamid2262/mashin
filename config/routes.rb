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
    end
  end

  resources :scraps, only: [:index] 
  resources :scrap_articles, only: [:index] 

  resource  :homes, only: [:show]
  resource  :dashboard, only: [:show]
  resources :car_models
  resources :locations
  resources :body_colors
  resources :internal_colors
  resources :makes
  resources :topics do
    resources :articles
  end
  # get '' => 'topics#index', constraints: lambda { |r| r.subdomain.present? and r.subdomain != "www" and r.subdomain=="home"}
  # get '' => 'topics#show',  constraints: lambda { |r| r.subdomain.present? and r.subdomain != "www" }

  root 'homes#show'
end
