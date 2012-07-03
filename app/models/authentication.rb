
#//
#// The AuthUser object stores users authenticated thru OmniAuth
#// Available columns: provider, uid, name, user_id (fk to table: users)
#//

class Authentication < ActiveRecord::Base

  belongs_to :user

  #//  Class methods
  class << self

    #// Retrieve omniauth user provided, or creates a
    #//  new user w/ omniauth credentials
    def from_omniauth(omniauth, user)
      find_by_provider_and_uid(omniauth["provider"], omniauth["uid"]) || create_with_omniauth(omniauth, user)
    end

    #// Create new user w/ omniauth credentials
    #// and also link it to an existing user
    #//  (note, if we cannot find a user, then the system need to create one prior to calling this method)
    def create_with_omniauth(omniauth, duser) #// duser is devise user
      create! do |auth_user|
        auth_user.provider = omniauth["provider"]
        auth_user.uid = omniauth["uid"]
        auth_user.name ||= omniauth['info']['nickname'] || omniauth['info']['name'] || omniauth['info']['email']
        auth_user.user = duser
      end
    end

  end



end
