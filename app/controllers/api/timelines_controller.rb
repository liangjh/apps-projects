

##
#  Timelines API gateway
#  Returns JSON that is compatible with the TimelineJS plugin
#  For rendering on saintstir
#
class Api::TimelinesController < Api::ApiController

  ## Note: this is fully public, since we need to render it for any user on the site
  skip_before_filter :check_auth
  skip_after_filter :log_request

  def data
    type = params[:type]
    return generate_error_response(["params"],"Missing timeline type") if type.nil?

    #  Get type from timeline service; render
    res_json = TimelineService.render_by_type(type)
    render_response(res_json, false)
  end

end

