
##
Saintstir::Application.routes.draw do

  # Root points to singular HomeController
  root :to => "home#show"
  # Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :controller => "home", :only => [:show]
  # "My" page - each user's customized page based on preferences set on site
  resource :my_page, :controller => "my_page", :only => [:show]
  # Edit my user profile (user model)
  resource :user_profile, :controller => "user_profile", :only => [:edit, :update]
  # Contact us / emailer
  resource :contact_us, :only => [:create, :show]

  # Static pages
  match "/statics/volunteer" => "statics#volunteer", :via => :get
  match "/statics/about" => "statics#about", :via => :get

  # Auth / Login / Logout
  # Callback for third party authentication / login callback
  # note: /auth/:provider URI is mapped by omniauth
  match "/auth/:provider/callback" => "authentications#create"
  match "/logout" => "authentications#destroy"
  match "/sign_out" => "authentications#destroy"

  #  Core saints controller
  match "/saints/embed_featured" => "saints#embed_featured"
  resources :saints, :only => [:index, :show, :favorite, :unfavorite, :is_favorite] do
    member do
      # Embeddables, popups
      get :blurb
      get :embed
      # Favorites feature
      get :is_favorite
      post :favorite
      post :unfavorite
    end

    # Postings feature
    resources :postings, :only => [:index, :create]
    match "/like_posting/:id" => "postings#like"
    match "/flag_posting/:id" => "postings#flag"
  end

  # Administrative modules / editing pages
  namespace :admin do
    resources :saints
    resources :postings
  end

  # Saintstir REST / JSON API
  namespace :api do
    match "/saints/search" => "saints#search", :via => :get
    match "/saints/attributes" => "saints#attributes", :via => :get
    match "/saints/details" => "saints#details", :via => :get
  end


end
