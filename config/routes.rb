Confforge::Application.routes.draw do
  resources :forms do
    resources :fields do
      resources :options
    end

    resources :rows
    
    member do
      get :thanks
      get :chart
      get :stats      
      post :password
      get :design
    end
  end
  
  match '/admin' => 'admin/base#index', :as => :admin
  namespace :admin do
    resources :forms do
      member do
        put :recommand
        get :stats
      end
    end 
    resources :users
    resources :pages 
  end

  match '/logout'          => 'sessions#destroy', :as => :logout
  match '/login'           => 'sessions#new', :as => :login
  match '/signup'          => 'users#new', :as => :signup
  match '/register'        => 'users#create', :as => :register
  match '/sitemap.:format' => 'sitemap#index', :as => :sitemap
  match '/forget_password' => 'users#forget_password', :as => :forget_password 
  match '/reset_password'  => 'users#reset_password', :as => :reset_password
  match '/account'         => 'users#setting', :as => :account
  put   '/update'          => 'users#update'
  put   '/lang'            => 'sessions#set_lang', :as => :lang

  resource :session
  resource :users
  
  scope '/oauth' do
    match '/login/:name'    => 'oauth#new',      :as => :oauth_login
    match '/callback/:name' => 'oauth#callback', :as => :oauth_callback
  end
  
  match '/thanks' => 'home#thanks', :as => :thanks
  match '/demo'   => 'home#demo', :as => :demo
  match '/tour'   => 'home#tour', :as => :tour
  root :to => 'home#index'           
  match '/*page', :to => 'pages#show'  
end