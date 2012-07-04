
#//
#//  Authentication integration into Saintstir.
#//  This controller manages the integration of external auth services
#//  (i.e. twitter, google, facebook, and other affiliates) into the
#//  Saintstir system
#//

class AuthenticationsController < ApplicationController

  #// Auth mechanisms currently integrated into Saintstir
  AUTH_TWITTER = "twitter"
  AUTH_FACEBOOK = "facebook"
  AUTH_GOOGLE = "google_oauth2"

  #// Map to friendly names for confirm/error messages
  AUTH_NAME_MAP = {
    AUTH_TWITTER => "Twitter",
    AUTH_FACEBOOK => "Facebook",
    AUTH_GOOGLE => "Google"
  }


  def create

    #// Get omniauth object from request
    omniauth = request.env["omniauth.auth"]

    #// omniauth not found - redirect to sign_in page, with error msg
    if (omniauth.nil?)
      flash[:error] = "Something went wrong.  Please try signing in again."
      redirect_to new_user_session_url
    end

    if (current_user)

      #// If user is already logged in, then two scenarios will occur:
      #//  (1) omniauth credentials already associated w/ a user -> return user
      #//  (2) omniauth credentials NOT associated w/ user -> create, then return user
      #//     (both of these actions above are handled by Authentication.from_omniauth)
      auth_user = Authentication.from_omniauth(omniauth, current_user)
      flash[:notice] = "Successfully linked your #{AUTH_NAME_MAP[omniauth['provider']]} account to your current saintstir account"
      redirect_to home_url

    else

      #// User has not been logged in yet.  There are two scenarios:
      #//  (1) user is found for this authentication, so sign in the user
      #//  (2) user is NOT found for this authentication, so create the authentication entry and
      #//      direct the user to a registration page to complete the signup process

      user = User.peek_omniauth(omniauth)
      if (user.present?)
        #// Get auth object - if DNE, will create and associate with this user object
        Authentication.from_omniauth(omniauth, user)
        sign_in(user)
      else
        #// Create auth object, and creates a new user object (go to registration page to complete)
        auth = Authentication.from_omniauth(omniauth, nil)
        session[:omniauth] = omniauth.except("extra")
        sign_in(auth.user) if (auth.present? && auth.user.present?)
      end

      if (current_user)
        flash[:notice] = "You've logged in as user: [#{current_user.username}] through #{AUTH_NAME_MAP[omniauth['provider']]}"
        redirect_to home_url
      else
        flash[:notice] = "You've logged in as user: [#{omniauth['info']['name']}] through #{AUTH_NAME_MAP[omniauth['provider']]}, but you need to associate your login with a Saintstir user.  Please complete the registration details below."
        redirect_to new_user_registration_url
      end

    end

  end

  #//  User is already logged in - remove affiliated account
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Removed your affiliated login from your saintstir account"
    redirect_to authentications_url
  end


end
