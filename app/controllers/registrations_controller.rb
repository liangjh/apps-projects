require 'country_select.rb'

#//
#//  We're overriding default devise behavior, since we're integration
#//  3rd party authentications (ie twitter, facebook, google, etc)...
#//

class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @user.new_record?

    #// Welcome email
    begin
      SaintMailer.welcome_to_saintstir(@user).deliver
    rescue Exception => ex
      Rails.logger.error ex
    end
  end

  def update
    super

    #// Send a email notifying the user that his/her details have been changed
    begin
      SaintMailer.account_details_change(current_user).deliver
    rescue Exception => ex
      Rails.logger.error ex
    end
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
