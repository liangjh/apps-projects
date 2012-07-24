
#//
#//  Base application controller class
#//  We have some basic checks for logged_in, super_user status, etc
#//

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :fb_like_enabled?

  def check_super_user
    if (!current_user.super_user?)
      flash[:error] = "Sorry, but you must be a super user to access this page"
      redirect_to home_path
    end
  end

  def show_fb_like
    @fb_like = true
  end

  def fb_like_enabled?
    (@fb_like == true)
  end


  def logged_in?
    return (!current_user.nil?)
  end

  def check_logged_in
    if (!current_user)
      flash[:error] = "Sorry, but you must be logged in to submit a posting."
      redirect_to new_user_session_path
    end
  end
end
