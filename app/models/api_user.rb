
##
#  Stores API users and their credentials
#  To integrate a new user - fill out details via rails console,
#  create a key and secret that will need to be passed via basic auth
#
class ApiUser < ActiveRecord::Base

  ##
  #  For purposes of authentication, do not retrieve any users which have been inactivated
  default_scope where(:active => true)

end

