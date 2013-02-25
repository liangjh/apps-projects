require 'gabba'

##
#  Base class for our APIs
#  Here we define our auth mechanism
#  Saintstir currently uses basic auth for controlling access
#
class Api::ApiController < ApplicationController
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
    generate_error_response if (@auth_user.nil?)

  end

  ##
  #  Generates an API error reponse,
  def generate_error_response
    render :status => 401,
           :json => {"success" => "false",
                     "errors" => ["autherror"],
                     "message" => "Authentication error"}
  end

  ##
  #  Logs this API request to our chosen usage API gateway
  #  To change logging destination, call different code paths
  def log_request

    begin

      # Log to regular rails log (dispatched to configured logging framework)
      Rails.logger.info "saintstir-api|app:#{@api_user.present? ? @api_user.app_name: "unknown"}|req:#{request.url}"

      # Log to google analytics
      # g = Gabba::Gabba.new('UA-24915422-1','saintstir.com')
      # g.set_custom_var(1, 'api.app_name', @api_user.app_name, Gabba::Gabba::SESSION)
      # g.page_view(request.url)

    rescue Exception => ex
      Rails.logger.error "AFailed to log request.  Reason: #{ex}"
    end
  end

end

