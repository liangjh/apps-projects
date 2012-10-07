
#//
#// Postings Events Controller
#// This controller takes postings & votes submissions from users on the saintstir site
#// Deals primarily with the Posting model
#//

class PostingsController < ApplicationController
  before_filter :check_logged_in, :only => [:create]
  before_filter :ajax_logged_in, :only => [:like, :flag]

  #// Number of postings per "page" on the saint profile page
  POSTINGS_PER_PAGE = 5

  #// parses params, and sets into instance vars a list of available postings
  #// this is called by the respective index methods
  def index
    #// Retrieve page number, and return postings
    @page = params[:page].nil? ? 1 : params[:page]
    @sort_by = params[:sort_by].nil? ? "date" : params[:sort_by]
    @saint_id = params[:saint_id]

    #// Retrieve all within page (using kaminari gem)
    #// Choose sorting methodology
    #// We'll sort either by "date" or "popular" (popularity, based on # of votes)
    if (@sort_by == "popular")
      @postings = Posting.by_saint_id(@saint_id).by_visible_status.includes(:user).
                          sort_by_popular.
                          page(@page).per(POSTINGS_PER_PAGE)
    else
      @postings = Posting.by_saint_id(@saint_id).by_visible_status.includes(:user).
                          sort_by_create.
                          page(@page).per(POSTINGS_PER_PAGE)
    end

    #// Render plain, w/o layout, since it'll be inset dynamically into existing page
    render :template => 'postings/index', :layout => false
  end

  #// Creates a posting object and saves to database
  #// there are two methods, one for prayers and the other for stories - they both call this,
  #// passing in a type
  def create

    #// Retrieve all params to create a posting
    saint_id = params[:saint_id]
    content  = params[:posting_data]
    anonymous = params[:anonymous]

    user_id  = current_user.id
    posting  = Posting.new(:status => Posting::STATUS_ACCEPT, :anonymous => ("true" == anonymous),
                           :user_id => user_id, :saint_id => saint_id, :content => content)

    #// Run validations; save posting if valid
    posting.save if (posting.valid?)

    #// Render in json,
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
    posting_id = params[:id]
    saint_id = params[:saint_id]

    #// For now, let anyone submit any number of likes - in the future we'll add uniqueness checks
    if (posting_id)
      posting = Posting.find(posting_id.to_i)

      if (posting.is_liked_by_user?(current_user))
        render :json => {"success" => false,
                         "errors" => ["Sorry, but you've already 'liked' this posting!"]}.to_json
      else

        #  Add 'like' entry to user_posting_likes model
        UserPostingLike.create_from_user_posting(current_user, posting)
        posting.increment_vote
        posting.save!

        render :json => {"success" => true,
                         "message" => "Thanks!  We're glad you liked this wall post."}.to_json
      end
    else
      render :json => {"success" => false, "errors" => ["Could not find saint or posting"]}.to_json
    end
  end

  #// Flags a posting as inappropriate
  def flag
    posting_id = params[:id]
    saint_id = params[:saint_id]

    if (posting_id)
      posting = Posting.find(posting_id.to_i)
      posting.update_attribute(:status, Posting::STATUS_PENDING)
      render :json => {"success" => true,
                       "message" => "We have received your request to flag this posting, and will review it as soon as possible.  Thanks!"}.to_json
    else
      render :json => {"success" => false, "errors" => ["Could not find saint or posting."]}.to_json
    end
  end


end



