
#
#  Main controller for the contact-us functionality
#
#

class ContactUsController < ApplicationController

  # Display the main template page
  def show
    # if the message and/or purpose params are passed, then set it
    # this is used for preselected options in the contact us form
    @message = params[:message] if (params[:message])
    @purpose = params[:purpose] if (params[:purpose])
  end

  # Send the email message, and
  def create
    #  Invoke the mailer
    if (params[:email].blank? || params[:message].blank?)
      flash[:notice] = nil
      flash[:error] = "Missing required parameters: email, or message"
    else
      SaintMailer.contact_us(current_user, params[:email], params[:purpose], params[:message]).deliver
      flash[:error] = nil
      flash[:notice] = "Got it!  Your message has been received.  If you're asking for help or someting urgent, we will get back to you as soon as possible."
    end
    render :show
  end
end



