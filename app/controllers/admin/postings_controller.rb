
#//
#//  Postings Workflow / editing module
#//  This controller allows an administrator to view all submitted / pending postings, and
#//  either approve or reject the posting. Reasons to reject the posting include inappropriate
#//  or offensive content
#//

class Admin::PostingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_super_user

  #// display as much as possible, why not
  POSTINGS_PER_PAGE = 20

  #//  Renders list of postings (by type)
  def index

    #// Retrieve the current status and page of the request (if exists)
    @status = (params[:status] || session[:postings_status] || Posting::STATUS_PENDING)
    @page = (params[:page] || session[:postings_page] || "1")

    #// Persist the page and status to the session
    session[:postings_status] = @status
    session[:postings_page] = @page

    #// always sort by date - and, we don't need to retrieve for a given saint,
    #// retrieve marked as "pending" (anything flagged) by default, but can retrieve al
    @postings = Posting.where(:status => @status).includes(:user).
                        sort_by_create.
                        page(@page).per(POSTINGS_PER_PAGE)

  end


  #//  Change the status of a posting
  def update

    #//  This is the status that we want to modify a given posting to
    @posting_status = params[:posting_status]
    @posting_id = params[:id]

    #// If posting exists, modify the posting
    posting = Posting.find(@posting_id.to_i)
    if (posting)
      posting.update_attribute(:status, @posting_status)
      SaintMailer.posting_rejected(posting).deliver if (@posting_status == Posting::STATUS_REJECT && !posting.user.nil? && !posting.user.email.nil?)
      flash[:notice] = "Successfully changed the status of the selected posting to: #{@posting_status}"
    else
      flash[:error] = "Failed to change the status of the posting. "
    end

    #// Render w/ index (and run thru any logic in index)
    redirect_to admin_postings_path

  end


  #// note: for now, don't implement "delete".
  #// we can have a regular cleanup from the database

end


