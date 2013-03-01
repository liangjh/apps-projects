
##
Saintstir::Application.routes.draw do

  # Root points to singular HomeController
  root :to => "home#show"
  resource :home, :controller => "home", :only => [:show]
  resource :my_page, :controller => "my_page", :only => [:show]
  resource :user_profile, :controller => "user_profile", :only => [:edit, :update]
  resource :contact_us, :only => [:create, :show]

  # Static pages
  match "/statics/volunteer" => "statics#volunteer", :via => :get
  match "/statics/about" => "statics#about", :via => :get
  match "/statics/developers" => "statics#developers", :via => :get

  # Authentication (3rd party) + Login / Logout
  #   Note: URI /auth/:provider is mapped to omniauth
  match "/auth/:provider/callback" => "authentications#create"
  match "/logout" => "authentications#destroy"
  match "/sign_out" => "authentications#destroy"

  # Core saints functionality
  resources :saints, :only => [:index, :show, :favorite, :unfavorite, :is_favorite] do
    member do
      get :blurb
      get :is_favorite
      post :favorite
      post :unfavorite
    end

    # Postings Integration
    resources :postings, :only => [:index, :create]
    match "/like_posting/:id" => "postings#like"
    match "/flag_posting/:id" => "postings#flag"
  end

  # Administrative modules / editing pages
  namespace :admin do
    resources :saints
    resources :postings
  end

  ## Developer / External Integrations

  # Embeddable Tiles
  match "/saints/embed_featured" => "saints#embed_featured", :via => :get
  match "/saints/:symbol/embed" => "saints#embed", :as => :embed_saint, :via => :get

  # Saintstir API
  namespace :api do
    match "/saints/search" => "saints#search", :via => :get
    match "/saints/attributes" => "saints#attributes", :via => :get
    match "/saints/metadata" => "saints#metadata", :via => :get
    match "/saints/details" => "saints#details", :via => :get
  end


end
