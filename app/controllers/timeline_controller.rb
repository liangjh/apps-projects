##
#  Renders and displays the saint timeline
#
class TimelineController < ApplicationController

  def show

    ##
    # Type of timeline
    # feast => feast day (all in current year)
    # century => 1..21
    # eurocentric_period => [(defined in configurations / taxonomy)]
    @timeline_data = TimelineService.render_feast

  end



end


