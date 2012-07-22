
#//
#// Core user authentication object
#//

class User < ActiveRecord::Base

  has_many :authentications
  has_many :postings
  has_many :user_posting_likes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me, :anonymous, :location_state, :location_country


  def has_voted_for?(posting)
    (user_posting_likes.where(:posting_id => posting.id).count > 0)
  end

  # Checks if a user is set as a super-user
  def super_user?
    (super_user == true)
  end

  # Associates this user with an omniauth credentials set
  def apply_omniauth(omniauth)

    #// if auth does not exist, then create a new one to be associated
    #// push the found auth into the association - the user may be new and will not have an id to
    #// complete the association in the database, so we assign in memory for now
    auth = authentications.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    auth = authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid']) if (auth.nil?)
    authentications << auth if (authentications.empty?)

    #// Try to set whatever properties we have in omniauth for this user
    #// Override w/ omniauth credentials if those fields don't exist in user objecta
    oauth_email = omniauth['info']['email']
    self.username ||= omniauth['info']['nickname'] || omniauth['info']['name'] || (oauth_email.split("@")[0] if (oauth_email.present?))
    self.email = oauth_email if (!self.email.present?)
  end

  # The password fields are overidden to be false if the user already
  # has authenticated with a third party
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  # if the user doesn't currently have a password, then its not necessary to pass
  # in the user's current password
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  class << self
    #// Given an omniauth user, check to see whether a saintstir user already exists with the
    #// same email address.  Return this user if so (otherwise nil)
    def peek_omniauth(omniauth)
      find_by_email(omniauth['info']['email']) if (omniauth['info']['email'])
    end

    #// Build a user from omniauth
    def create_omniauth_user(omniauth)
      user = User.new
      user.email = omniauth['info']['email']
      user.username ||= omniauth['info']['nickname'] || omniauth['info']['name']
      user.save!
    end

  end


end
