Saintstir::Application.routes.draw do

  #//  Root points to singular HomesController
  root :to => "homes#show"

  #//  Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :only => [:show]

  #//  Static resources (named resources)
  match "/statics/volunteer" => "statics#volunteer", :via => :get
  match "/statics/about" => "statics#about", :via => :get

  #//  Devise user login / auth routes
  #//  We override the registrations and sessions controllers to accomodate third party auth
  devise_for :users, :controllers => { :registrations => "registrations" }

  #// Authentication routes using OmniAuth
  resources :authentications
  match "/auth/:provider/callback" => "authentications#create" #// callback for 3rd party integration
  match "/authentications/create" => "authentications#create"  #// given a prior omniauth session, associate w/ new login

  #//  Core saints controller, with ajax events
  #//  index => saint explore page
  #//  show  => saint profile page
  #//  blurb => saint modal hover-over
  resources :saints, :only => [:index, :show] do
    member do
      get :blurb #// displays small blurb of saint profile info (render in modal)
    end
  end

  #//  Administrative / Editor Modules
  namespace :admin do
    resources :saints
  end

end
