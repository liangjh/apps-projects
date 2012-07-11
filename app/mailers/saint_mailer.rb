
#// Mailer for contact us

class SaintMailer < ActionMailer::Base


  #  For questions submitted on the "contact us" section of the website
  def contact_us(current_user, from_email, purpose, message)
    @user = current_user
    @message = message.gsub(/\n/, "<br/>")
    mail(:to => "saintstir@gmail.com", :from => from_email, :cc => from_email, :subject => purpose)
  end


end
