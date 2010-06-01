Confforge::Application.routes.draw do
  resources :forms do
    resources :fields do
      resources :options
    end

    resources :rows do
      collection do
        post :edit_individual
        put :update_individual
      end
    end
    
    collection do
      post :edit_individual
      put  :update_individual
    end
    
    member do
      get :thanks
    end
  end

  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/signup' => 'users#new', :as => :signup
  match '/register' => 'users#create', :as => :register
  match '/sitemap.:format' => 'sitemap#index', :as => :sitemap
  
  resource :session
  resource :users
  
  match '/thanks' => 'home#thanks', :as => :thanks
  root :to => 'home#index'
  match '/:controller(/:action(/:id))'
end