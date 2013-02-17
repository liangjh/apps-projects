require 'country_select'

##
#  Editing of the user record
#  Available only to the currently signed in user
#
class UserProfileController < ApplicationController
  before_filter :check_logged_in

  ##
  #  Display the user record
  def edit
    @user = current_user
  end

  ##
  #  Update the user record
  def update
    @user = current_user
    user_params = request[:user]

    #  Save submitted attributes, and then send an email to notify user
    if (user_params.present?)
      success = @user.update_attributes(user_params)
      SaintMailer.account_details_change(@user).deliver if (success)
    end

    # Go back to profile edit page
    render :action => 'edit'
  end


end
