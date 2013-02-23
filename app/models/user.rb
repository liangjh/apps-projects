
#//
#// Core user authentication object
#//

class User < ActiveRecord::Base

  has_many :authentications
  has_many :postings
  has_many :user_posting_likes
  has_many :saints, :through => :favorites
  has_many :favorites

  # All validations - require username
  # Don't require email, b/c some third party services don't expose email!  (twitter)
  validates :username, :presence => true
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :allow_blank => true
  validates :username, :uniqueness => true


  def has_voted_for?(posting)
    (user_posting_likes.where(:posting_id => posting.id).count > 0)
  end

  # Checks if a user is set as a super-user
  def super_user?
    (super_user == true)
  end

  ##
  #  Update metrics on this user
  #  last sign in, and count (add'l stuff can be added to this)
  def up_metrics
    self.last_sign_in_at = Time.zone.now
    self.sign_in_count = 0 if (self.sign_in_count.nil?)
    self.sign_in_count += 1
    self.save
  end

  class << self

    ##
    #  Given an omniauth user, check to see whether a saintstir user already exists
    #  Return this user if so (otherwise nil)
    def peek_omniauth(omniauth)
      user = nil
      user = self.find_by_email(omniauth['info']['email']) if (omniauth['info']['email'].present?)
      if (user.nil?)
        user = self.find_by_username(omniauth['info']['nickname']) || self.find_by_username(omniauth['info']['name'])
      end
      user
    end

    ##
    #  Create from omniauth
    #  Build a user from omniauth
    def create_from_omniauth(omniauth)
      user = User.new
      # Set email, if this field exists
      user.email = omniauth['info']['email'] if (omniauth['info']['email'].present?)
      user.username ||= omniauth['info']['nickname'] || omniauth['info']['name']
      user.save!
      user
    end

  end


end
