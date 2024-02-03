
##
#  Homepage
class HomeController < ApplicationController
  before_filter :show_fb_like
  after_filter :set_last_page

  def show

    #  Retrieve the next saint of the day
    @saint = Api::SaintOfDay.get

  end



end
