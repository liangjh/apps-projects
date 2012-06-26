class ApplicationController < ActionController::Base
  protect_from_forgery

  def check_super_user
    if (!current_user.super_user?)
      flash[:error] = "Sorry, but you must be a super user to access this page"
      redirect_to home_path
    end
  end

  def check_logged_in
    (current_user ? true : false)
  end

end
