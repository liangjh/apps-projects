Saintstir::Application.routes.draw do

  #//  Root points to singular HomeController
  root :to => "home#show"

  #//  Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :controller => "home", :only => [:show]

  #//  Static resources (named resources)
  match "/statics/volunteer" => "statics#volunteer", :via => :get
  match "/statics/about" => "statics#about", :via => :get

  #//  Authentication routes, via (1) Omniauth, (2) Devise
  #//  We override the registrations and sessions controllers to accomodate third party auth
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :authentications, :only => [:create, :destroy]
  match "/auth/:provider/callback" => "authentications#create" #// callback for 3rd party integration
  match "/authentications/create" => "authentications#create"  #// given a prior omniauth session, associate w/ new login

  #//  Core saints controller, with ajax events
  #//  index => saint explore, show  => saint profile, blurb => saint peek hover-over
  resources :saints, :only => [:index, :show, :favorite, :unfavorite, :is_favorite] do
    member do

      #// Ajax blurb
      get :blurb

      #// Favorites feature
      get :is_favorite
      post :favorite
      post :unfavorite
    end

    #// Posting actions - list, create, like, flag
    resources :postings, :only => [:index, :create]
    match "/like_posting/:id" => "postings#like"
    match "/flag_posting/:id" => "postings#flag"
  end


  #//  Singular controller for contact us page
  resource :contact_us, :only => [:create, :show]

  #//  Administrative modules / editing pages
  namespace :admin do
    resources :saints
    resources :postings
  end

end
