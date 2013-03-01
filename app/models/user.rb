
##
#  Core user object
#  User pedigree info stored in this table
#

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
      user = self.find_by_email(omniauth.email) if (omniauth.email.present?)
      if (user.nil?)
        user = self.find_by_username(omniauth.nickname) || self.find_by_username(omniauth.name)
      end
      user
    end

    ##
    #  Create from omniauth
    #  Build a user from omniauth
    def create_from_omniauth(omniauth)
      user = User.new
      # Set email, if this field exists
      user.email = omniauth.email if (omniauth.email.present?)
      user.username ||= omniauth.nickname || omniauth.name
      user.save!
      user
    end

  end


end
