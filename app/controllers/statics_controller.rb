

##
#  Static pages controller
#  All static pages have routes configured for a methodo n
#  this controller (and corresponding view)
#
class StaticsController < ApplicationController

  ##
  #  All pages available
  #  These pages are fully public (no before filter configured)
  def volunteer; end
  def about; end
  def developers; end

end

