##
#  Timeline Service
#  Renders and displays the saint timeline
#
class TimelineController < ApplicationController
  before_filter :show_fb_like, :only => [:show]

  def show

    # Retrieve data by type, default to feast day
    # The view (js lib) will dispatch to the timeline API rendering endpoint
    # To retrieve the timeline we intend to render
    @type = params[:type].present? ? params[:type] : TimelineService.timelines.first.type
    @zoom_adjustment = TimelineService.timeline_by_type(@type).zoom_adjustment
    set_page_title("Timeline: #{TimelineService.timeline_by_type(@type).name}")
  end


end


