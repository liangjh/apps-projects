require 'page_preferences'

#//
#//  Base application controller class
#//  We have some basic checks for logged_in, super_user status, etc
#//

class ApplicationController < ActionController::Base

  # This module has all of the page-available settings on the system
  include PagePreferences

  protect_from_forgery
  helper_method :fb_like_enabled?, :favorite_link_enabled?
  helper_method :page_title

  def check_super_user
    if (!current_user.super_user?)
      flash[:error] = "Sorry, but you must be a super user to access this page"
      redirect_to home_path
    end
  end

  def logged_in?
    return (!current_user.nil?)
  end

  ##
  # Redirects (http 302) to login page if user is not logged in
  def check_logged_in
    if (!current_user)
      flash[:error] = "Sorry, but you must be logged in to do this.  Please sign in or create a Sainstir account"
      redirect_to new_user_session_path
    end
  end

  #// if user is not logged in, will return a json error (for rendering on client-side)
  def ajax_logged_in
    if (!logged_in?)
      render :json => {"success" => false,
                       "errors" => ["You must be logged in to do this"],
                       "message" => "Sorry, but you must be logged in to do this.  Please sign in or create a Saintstir account."}.to_json
    end
    logged_in?
  end

  ##
  #  Returns a 401 HTTP status if user is not logged in
  def authorize_logged_in
    render :status => 401 if (!current_user)
  end

end
