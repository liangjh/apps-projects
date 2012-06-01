Saintstir::Application.routes.draw do

  #//  Root points to singular HomesController
  root :to => "homes#show"

  #//  Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :only => [:show]

  #//  Static resources (named resources)
  match "/statics/volunteer" => "statics#volunteer", :via => :get
  match "/statics/about" => "statics#about", :via => :get

  #//  User login / auth routes
  #//  Generate devise-related routes (auth/login)
  devise_for :users

  #//  Core saints controller, with ajax events
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
