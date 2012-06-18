
#//
#// Core user authentication object
#//

class User < ActiveRecord::Base

  has_many :authentications

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me

  # Checks if a user is set as a super-user
  def super_user?
    (super_user == true)
  end

  # Associates this user with an omniauth credentials set
  def apply_omniauth(omniauth)
    #// link the passed-in omniauth to this user account
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])

    #// Try to set whatever properties we have in omniauth for this user
    #// Override w/ omniauth credentials if those fields don't exist in user object
    self.username ||= omniauth['info']['nickname'] || omniauth['info']['name']
    self.email = omniauth['info']['email'] if (!self.email.present?)
  end

  # The password fields are overidden to be false if the user already
  # has authenticated with a third party
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

end
