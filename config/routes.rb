Saintstir::Application.routes.draw do

  #//  Root points to singular HomesController
  root :to => "homes#show"

  #//  Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :only => [:show]

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
  resources :saints, :only => [:index, :show] do
    member do
      get :blurb
    end

    #// Posting actions (listing & create new)
    resources :postings, :only => [:index, :create]
    #// 'Like' a posting
    match "/like_posting/:id" => "postings#like"

  end

  #//  Administrative / Editor Modules
  namespace :admin do
    resources :saints
  end

end
