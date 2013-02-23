

##
#  This object stores the omniauth hash
#
class OmniauthNode

  def initialize(omniauth = {})
    @omniauth = omniauth
  end

  def email
    @omniauth['info']['email']
  end

  def nickname
    @omniauth['info']['nickname']
  end

  def name
    @omniauth['info']['name']
  end

  def provider
    @omniauth['provider']
  end

  def uid
    @omniauth['uid']
  end



end



