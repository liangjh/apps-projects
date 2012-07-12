
#//
#// Outgoing mailer for EVERYTHING in Saintstir
#//

class SaintMailer < ActionMailer::Base

  #  For questions submitted on the "contact us" section of the website
  def contact_us(user, from_email, purpose, message)
    @user = user
    @message = message.gsub(/\n/, "<br/>")
    mail(:content_type => "text/html",
         :to => "saintstir@gmail.com", :from => from_email, :cc => from_email,
         :subject => "Saintstir Inquiry: #{purpose}")
  end

  #  When a posting has been rejected, send a note to the original author of the posting
  def posting_rejected(posting)
    @posting = posting
    @user = posting.user
    mail(:content_type => "text/html",
         :to => @posting.user.email, :from => "saintstir@gmail.com",
         :subject => "Your posting on Saintstir was removed")
  end

  #  When a user has modified his/her account details, send a note
  def account_details_change(user)
    @user = user
    mail(:content_type => "text/html",
         :to => @user.email, :from => "saintstir@gmail.com",
         :subject => "Your account on Saintstir")
  end

  #  Registration welcome (or initial user creation)
  def welcome_to_saintstir(user)
    @user = user
    mail(:content_type => "text/html",
         :to => @user.email, :from => "saintstir@gmail.com",
         :subject => "Welcome to Saintstir")
  end


end
