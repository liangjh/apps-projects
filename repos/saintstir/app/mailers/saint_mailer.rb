#@
# Outgoing mailer for all communications in Saintstir
#
class SaintMailer < ActionMailer::Base

  SAINTSTIR_EMAIL = "info@saintstir.com"


  #  For questions submitted on the "contact us" section of the website
  def contact_us(user, from_email, purpose, message)
    @user = user
    @from_email = from_email
    @message = message.gsub(/\n/, "<br/>")
    mail(:content_type => "text/html",
         :to => SAINTSTIR_EMAIL, :from => from_email, :cc => from_email,
         :subject => "Saintstir Inquiry: #{purpose}")
  end

  #  When a posting has been rejected, send a note to the original author of the posting
  def posting_rejected(posting)
    @posting = posting
    @user = posting.user
    send_email("Your posting on Sainstir was removed", posting.user.email)
  end

  #  When a user has modified his/her account details, send a note
  def account_details_change(user)
    @user = user
    send_email("Your account on Saintstir", user.email)
  end

  #  Registration welcome (or initial user creation)
  def welcome_to_saintstir(user)
    @user = user
    send_email("Welcome to Saintstir", user.email)
  end

  #  API invitation
  def api_invite_tou(api_user)
    @api_user = api_user
    send_email("Saintstir API Invitation", api_user.email)
  end

  #  API welcome (TOU already accepted)
  def api_welcome(api_user)
    @api_user = api_user
    send_email("Saintstir API Credentials", api_user.email)
  end

  private

   def send_email(subject, email_address)
    mail(:content_type => "text/html",
         :to => email_address, :from => SAINTSTIR_EMAIL,
         :subject => subject)
   end


end
