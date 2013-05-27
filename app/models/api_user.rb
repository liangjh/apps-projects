
##
#  Stores API users and their credentials
#  To integrate a new user - fill out details via rails console,
#  create a key and secret that will need to be passed via basic auth
#
class ApiUser < ActiveRecord::Base

  ##
  #  For purposes of authentication, do not retrieve any users which have been inactivated
  default_scope where(:active => true)

  def accept_tou
    self.update_attributes(:accepted_tou => true, :accepted_tou_ts => Time.zone.now)
  end

  def reject_tou
    self.update_attributes(:accepted_tou => false, :accepted_tou_ts => Time.zone.now)
  end

  ##
  #  Create user, including a randomly generated UUID for key and secret.
  #  Send email invitation to user
  def self.api_invitation(name, app_name, email)

    if (ApiUser.find_by_app_name(app_name))
      raise Exception.new("Registration with app name already created")
    end

    #  Generate random alphanumeric key / secret
    random_key = UUIDTools::UUID.random_create.hexdigest[0..12]
    random_secret = UUIDTools::UUID.random_create.hexdigest[0..12]
    api_user = ApiUser.create(:name => name, :app_name => app_name, :email => email, :key => random_key, :secret => random_secret)
    #  Send TOU invitation to api user
    SaintMailer.api_invite_tou(api_user).deliver

  end


end

