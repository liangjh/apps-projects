class ApplicationController < ActionController::Base
  protect_from_forgery

  GO_STATSLY_GO = "Go Statsly Go"

  def submitted_form?
    params[:commit].present? && params[:commit] == GO_STATSLY_GO
  end

end
