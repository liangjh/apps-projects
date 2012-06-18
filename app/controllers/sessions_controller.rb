
#//
#//  Overriding default devise behavior in order to integrate
#//  sign in bindings with 3rd party authentication services
#//

class SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    #// OmniAuth 3rd-party Integration
    #//  User has signed in, so we now want to direct the user to the
    #//  authentications url, which will take care of binding the current user
    #//  to the third-party auth
    if (session[:omniauth])
      redirect_to authentications_create_url
    end

    respond_with resource, :location => after_sign_in_path_for(resource)
  end


end
