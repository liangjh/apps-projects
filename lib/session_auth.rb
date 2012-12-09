
##
#  Session auth - methods for inclusion into application controller
#  related to user management and authentication across pages / controllers
module SessionAuth

  ##
  #  Get the currently logged in user
  def current_user
    @current_user ||= User.find(session[:user_id]) if (session && session[:user_id])
  end

  ##
  #  Set the current user
  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  ##
  #  Sign in a user explicitly
  def sign_in(user)
    self.current_user = user
  end

  ##
  #  sign out a user explicitly
  def sign_out
    @current_user = nil
    session[:user_id] = nil
  end


  def check_super_user
    if (!self.current_user.super_user?)
      flash[:error] = "Sorry, but you must be a super user to access this page"
      redirect_to home_path
    end
  end

  def logged_in?
    return (!self.current_user.nil?)
  end

  ##
  # Redirects (http 302) to login page if user is not logged in
  def check_logged_in
    if (!self.current_user)
      flash[:error] = "Sorry, but you must be logged in to do this.  Please sign in or create a Sainstir account"
      redirect_to home_path
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
