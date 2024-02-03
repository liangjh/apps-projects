
##
#  Postings Events Controller
#  Screen interactivity for postings - generates postings view and handles API-based actions
#  for posting creation, likes, and flags
#
class PostingsController < ApplicationController
  before_filter :check_logged_in, :only => [:create]
  before_filter :ajax_logged_in, :only => [:like, :flag]

  # Included Modules
  include Api::Postings

  ##
  #  Parses params, and sets into instance vars a list of available postings
  #  This is called by the respective index methods
  def index
    # Retrieve postings
    postings_list(params)
    # Render w/o layout, since it'll be inset dynamically into existing page
    render :template => 'postings/index', :layout => false
  end

  ##
  # Creates a posting object and saves to database
  # there are two methods, one for prayers and the other for stories - they both call this,
  # passing in a type
  def create
    posting = posting_create(current_user, params)
    if (!posting.nil? && posting.errors.size > 0)
      render :json => {"success" => false, "errors" => posting.errors.messages.values.flatten,
                       "message" => "Click on 'Write on wall' above and revise - don't worry, your stuff is still there!"}.to_json
    else
      render :json => {"success" => true,
                       "message" => "Got it!  Thanks for posting!"}.to_json
    end

  end

  #// Submits a 'like' for this posting
  def like
    success = posting_like(current_user, params)
    if (success)
      render :json => {"success" => true,
                       "message" => "Thanks!  We're glad you liked this wall post."}.to_json
    else
      render :json => {"success" => false, "errors" => ["Could not find saint or posting"]}.to_json
    end
  end

  ##
  # Flags a posting as having inappropriate content
  def flag
    success = posting_flag(params)
    if (success)
      render :json => {"success" => true,
                       "message" => "We have received your request to flag this posting, and will review it as soon as possible.  Thanks!"}.to_json
    else
      render :json => {"success" => false, "errors" => ["Could not find saint or posting."]}.to_json
    end
  end


end



