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
    end
  end

  resources :scraps, only: [:show, :index] do
    collection do
      post "scrap" 
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
