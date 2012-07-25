
#//
#// The home controller leads to the homepage
#// Main functionality will include "saint of the day" as well as other data-driven
#// displays designed for the homepage
#//

class HomeController < ApplicationController
  before_filter :show_fb_like

  def show
    #//  leads to homepage by default

    #// Retrieve the featured saint so that we can generate "saint of the day" widget
    featured_saint_code = Setting.by_key("saint_featured").first.value
    @saint = Saint.by_symbol(featured_saint_code).first
  end



end
