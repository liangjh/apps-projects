
#//
#// Postings Events Controller
#// This controller takes postings & votes submissions from users on the saintstir site
#// Deals primarily with the Posting model
#//

class PostingsController < ApplicationController

  # do explicit checks in data
  # before_filter :check_logged_in, :only => [:create_prayer, :create_story]

  #// Number of postings per "page" on the saint profile page
  POSTINGS_PER_PAGE = 5

  #// parses params, and sets into instance vars a list of available postings
  #// this is called by the respective index methods
  def index
    #// Retrieve page number, and return postings
    @page = params[:page].nil? ? 1 : params[:page]
    @saint_id = params[:saint_id]

    #// Retrieve all within page (using kaminari gem)
    @postings = Posting.by_saint_id(@saint_id).sort_by_create.page(@page).per(POSTINGS_PER_PAGE)

    #// Render plain, w/o layout, since it'll be inset dynamically into existing page
    render :template => 'postings/index', :layout => false
  end

  #// Creates a posting object and saves to database
  #// there are two methods, one for prayers and the other for stories - they both call this,
  #// passing in a type
  def create

    #// check whether user is logged in - if not, return an error
    if (!logged_in?)
      render :json => {"success" => false, "errors" => ["You must be logged into Saintstir to post a prayer"]}.to_json
      return
    end

    #// Retrieve all params to create a posting
    saint_id = params[:saint_id]
    content  = params[:posting_data]
    anonymous = params[:anonymous]

    user_id  = current_user.id
    posting  = Posting.new(:status => Posting::STATUS_PENDING, :anonymous => ("true" == anonymous),
                           :user_id => user_id, :saint_id => saint_id, :content => content)

    #// Run validations; save posting if valid
    posting.save if (posting.valid?)

    #// Render in json,
    if (posting.errors.size > 0)
      render :json => {"success" => false, "errors" => posting.errors.messages.values.flatten}.to_json
    else
      render :json => {"success" => true}.to_json
    end

  end
  #// Submits a 'like' for this posting
  def like
    posting_id = params[:id]
    saint_id = params[:saint_id]

    #// For now, let anyone submit any number of likes - in the future we'll add uniqueness checks
    if (posting_id && saint_id)
      posting = Posting.find(posting_id.to_i)
      posting.votes = 0 if (posting.votes.nil?)
      posting.votes += 1
      posting.save
      render :json => {"success" => true}.to_json
    else
      render :json => {"success" => false, "errors" => ["Could not find saint or posting."]}.to_json
    end


  end


end



