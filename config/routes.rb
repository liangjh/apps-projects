Saintstir::Application.routes.draw do

  #//  Root points to singular HomesController
  root :to => "homes#show"

  #//  Define homepage as singular resource, since all ppl share the same homepage content
  resource :home, :only => [:show]

  #//  Generate devise-related routes (auth/login)
  devise_for :users

  #//  Administrative / Editor Modules
  #//  Saints Editor Module
  resources :saints

end
