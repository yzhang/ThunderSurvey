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
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  resources :users
  resource :session
  match '/thanks' => 'home#thanks', :as => :thanks
  match '/' => 'forms#index'
  match '/:controller(/:action(/:id))'
end