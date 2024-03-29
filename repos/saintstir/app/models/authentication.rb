
##
#  The Authentication model stores registered authentications via Omniauth
#  and 3pd auth services such as facebook, twitter, google, etc
#

class Authentication < ActiveRecord::Base

  belongs_to :user

  #//  Class methods
  class << self

    ##
    #  Finds an an existing authentication (if one exists already for this user).  If one does not exist, then
    #  create a new authentication (not associated with a user yet)
    def find_or_create_from_omniauth(omniauth)
      find_by_provider_and_uid(omniauth.provider, omniauth.uid) || self.create_with_omniauth(omniauth)
    end

    ##
    #  Creates an authentication object with params
    def create_with_omniauth(omniauth)
      create! do |auth|
        auth.provider = omniauth.provider
        auth.uid = omniauth.uid
        auth.name = omniauth.nickname || omniauth.name
      end
    end

    ##
    #  Associates a user with an auth
    def save_user(auth, user)
      auth.user = user
      auth.save!
    end

  end



end
