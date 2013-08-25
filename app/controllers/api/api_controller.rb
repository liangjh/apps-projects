require 'gabba'

##
#  Base class for our APIs
#  Here we define our auth mechanism
#  Saintstir currently uses basic auth for controlling access
#
class Api::ApiController < ActionController::Base
  before_filter :check_auth
  after_filter :log_request

  ##
  #  This retrieves the basic auth parameters and compares them against
  #  the user key/secret in the API database
  def check_auth

    #  Retrieve user associated with this key/secret
    #  this impl will automatically decode the base64-encoded values
    @auth_user = authenticate_with_http_basic do |key, secret|
      ApiUser.find_by_key_and_secret(key, secret) if (key.present? && secret.present?)
    end

    # No user found: render a 401 and an error json
    if (@auth_user.nil?)
      generate_auth_error_response
      return
    end

    # Check whether api user has been enabled
    if (!@auth_user.accepted_tou)
      generate_disabled_tou_response
      return
    end

  end

  ##
  #  Account has either been disabled, or user has not accepted TOU
  def generate_disabled_tou_response
    render :status => 500,
           :json => {"success" => "false",
                     "errors" => ["tou_unaccepted"],
                     "message" => "Terms of use not accepted"}
  end

  ##
  #  Generates an API error reponse,
  def generate_auth_error_response
    render :status => 401,
           :json => {"success" => "false",
                     "errors" => ["autherror"],
                     "message" => "Authentication Error"}
  end

  ##
  #  Generic error response
  def generate_error_response(errors = [], message = "Unknown Error")
    render :status => 500,
           :json => {"success" => "false",
                     "errors" => errors,
                     "message" => message}
  end

  ##
  # This is the API wrapper around the render method.
  # This will ensure that the license is added to any downstream api calls
  def render_response(resp, include_license = true)
    #  Add the licensing parameters to this
    resp[:license] = license_details if include_license
    render :json => resp
  end

  ##
  #  Generate rendering for the license
  def license_details
    {
      :description => AppLicensing::CC_LICENSE_BLURB,
      :link => AppLicensing::CC_LICENSE_LANG_URL
    }
  end


  ##
  #  Logs this API request to our chosen usage API gateway
  #  To change logging destination, call different code paths
  def log_request

    begin

      # Log to regular rails log (dispatched to configured logging framework)
      Rails.logger.info "saintstir-api|#{@auth_user.present? ? @auth_user.app_name: "unknown"}|#{request.url}"

      # Log to google analytics
      if @api_user
        g = Gabba::Gabba.new(GoogleAnalyticsCredentials::GA_ACCOUNT_ID, GoogleAnalyticsCredentials::GA_ACCOUNT_DOMAIN)
        g.set_custom_var(1, 'api.app_name', @api_user.app_name, Gabba::Gabba::PAGE)
        g.page_view(request.url)
      end

    rescue Exception => ex
      Rails.logger.error "Failed to log request.  Reason: #{ex}"
    end
  end

end

