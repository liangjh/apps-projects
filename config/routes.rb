Statsly::Application.routes.draw do

  #  Home controller, @ root
  root :to => "home#show"
  resource :home, :controller => "home", :only => [:show]

  # Interactive Screens
  resource :binomial, :controller => "binomial", :only => [:show]
  resource :zdist, :controller => "zdist", :only => [:show]
  resource :tdist, :controller => "tdist", :only => [:show]

end
