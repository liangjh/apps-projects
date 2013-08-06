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
    @type = params[:type]
    data = TimelineService.render_by_type(@type)
    data.to_json

  end



end


