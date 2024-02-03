
##
#  Terms of use controller
#  This is to allow API users to accept the API terms of use
#
class TousController < ApplicationController

  ##
  # Display a single terms of use (note: id is the api key)
  # If key is not found, then redirect to a not found page in /public
  def show
    api_key = params[:id]
    @api_user = ApiUser.find_by_key(api_key) if api_key.present?
    if (@api_user.nil?)
      flash[:error] = "Sorry!  We couldn't find any account associated with that key.  Please use the contact us link to request a reset or a new key.  Thanks."
      redirect_to home_path
    else
      # only prompt if the TOU has not had any actions taken on it yet (accept or reject)
      if @api_user.accepted_tou.nil?
        render :template => 'tous/tou_prompt'
      else
        # TOU for a given account can only be run once.  O/W will require reacceptance of TOU
        flash_msg  = "Hi there!  It looks like you've already taken an action on this api key.  "
        flash_msg += "If you've forgotten your api key or secret, please use the contact us link to request a reset.  Thanks."
        flash[:error] = flash_msg
        redirect_to home_path
      end
    end
  end


  ##
  # Action to acccept TOU
  def update
    api_key = params[:id]
    terms_accept = params[:terms_accept]
    @api_user = ApiUser.find_by_key(api_key) if api_key.present?

    # API key not found - return
    if (@api_user.nil?)
      flash[:error] = "Sorry!  We couldn't find any account associated with that key.  Please use the contact us link to request a reset or a new key.  Thanks."
      redirect_to home_path
    else
      # Response keyed: fork to specific page
      if (terms_accept == 'accept')
        @api_user.accept_tou
        SaintMailer.api_welcome(@api_user).deliver
        render :template => 'tous/accept'
      else
        @api_user.reject_tou
        render :template => 'tous/reject'
      end
    end
  end


end




