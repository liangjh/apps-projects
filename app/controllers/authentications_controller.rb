
#//
#//  Authentication integration into Saintstir.
#//  This controller manages the integration of external auth services
#//  (i.e. twitter, google, facebook, and other affiliates) into the
#//  Saintstir system
#//

class AuthenticationsController < ApplicationController

  # Map of provider codes to friendly / display name
  AUTH_PROVIDER_NAME_MAP = {"facebook" => "Facebook", "google_oauth2" => "Google" }

  ##
  #  Handles omniauth callback
  #  Creates an authentication entry, and associates with a given user record
  #  on the system.  Creates user if necessary.  Performs user login
  #
  def create

    # Omniauth params
    omniauth = request.env['omniauth.auth']
    new_user_created = false

    # Is user already logged in?
    # Don't do any of this if he/she is logged in already
    unless (logged_in?)

      # Does user exist in authentications?
      # If DNE => create user in authentications
      auth = Authentication.find_or_create_from_omniauth(omniauth)

      # Does user have a user profile record?
      # If DNE => create new user (w/ implied info from authentications)
      # Send user a welcome email
      user = auth.user || User.peek_omniauth(omniauth)
      if (user.nil?)
        user = User.create_from_omniauth(omniauth)
        SaintMailer.welcome_to_saintstir(user).deliver
        new_user_created = true
      end

      # Associate auth with user (if DNE)
      Authentication.save_user(auth, user) if (auth.user.nil?)

      # Set login metrics (last login time, login count)
      User.up_metrics(user)

      # Set user as current_user
      sign_in(user)

      # Set a flash message for the user
      flash_msg =  "You've signed in successfully with your #{AUTH_PROVIDER_NAME_MAP[auth.provider]} account.  "
      flash_msg += "A saintstir account has been created for you, since you are a new user. " if (new_user_created)
      flash[:notice] = flash_msg

    end

    ##
    # Page Redirect
    # If first time login / user just created => go to profile page
    # If veteran login => go to original page
    if (new_user_created)
      redirect_to edit_user_profile_path
    else
      if (last_page.present?)
        redirect_to last_page
      else
        redirect_to home_path
      end
    end
  end

  ##
  #  Signs out the user
  def destroy
    sign_out
    flash[:notice] = "See you soon!"
    redirect_to home_path
  end


end
