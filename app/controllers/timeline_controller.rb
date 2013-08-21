##
#  Renders and displays the saint timeline
#
class TimelineController < ApplicationController

  def show
    # Retrieve data by type, default to feast day
    @type = params[:type] || TimelineService::Types::FEASTDAY
    # Get cached data
    @timeline_data = TimelineService.render_by_type(@type)
  end


end


