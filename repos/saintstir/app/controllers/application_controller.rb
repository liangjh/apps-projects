require 'page_preferences'
require 'session_auth'

#//
#//  Base application controller class
#//  We have some basic checks for logged_in, super_user status, etc
#//

class ApplicationController < ActionController::Base

  include PagePreferences  # page-wide settings tuning
  include SessionAuth      # user mgmt and authentication

  protect_from_forgery

  # page preferences methods - expose as helper methods
  helper_method :fb_like_enabled?, :favorite_link_enabled?, :page_title, :set_page_title
  # session auth methods - expose as helper methods
  helper_method :current_user, :check_logged_in, :sign_in, :sign_out


  ##
  #  The last page that the user was on - this is used to ensure that
  #  we can direct the user to his/her last viewed page
  def set_last_page
    session[:last_page] = request.fullpath if (request.fullpath.present?)
  end

  def last_page
    session[:last_page]
  end



end
