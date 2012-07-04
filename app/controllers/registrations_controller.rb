require 'country_select.rb'

#//
#//  We're overriding default devise behavior, since we're integration
#//  3rd party authentications (ie twitter, facebook, google, etc)...
#//

class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end


  #//  this method is called by create() and new() in devise - we're overriding to
  #//  provide some custom behavior to bind an authentication strategy with the current
  #//  devise user
  def build_resource(*args)
    super
    if (session[:omniauth])
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

end
