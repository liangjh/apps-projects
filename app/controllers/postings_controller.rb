
#//
#// Postings Events Controller
#// This controller takes postings & votes submissions from users on the saintstir site
#// Deals primarily with the Posting model
#//

class PostingsController < ApplicationController

  #// returns a list of available postings
  def index
    #// Retrieve page number, and return postings
    p_type   = params[:type].nil? ? Posting::TYPE_STORY : params[:type]
    page_num = params[:page].nil? ? 1 : params[:page]
    saint_id = params[:saint_id]

    #// Prayer postings remain anonymous, but story postings attributions will be visible for all to see
    @show_author = (p_type == Posting::TYPE_PRAYER ? false : true)
    @postings = Posting.by_saint_id(saint_id).page(page_num).per(5)
    render :layout => false
  end

  #// creates a new posting object
  def create
    puts "****** RECEIVED A REQUEST FOR PostingsController#create *******"
    puts "****** PARAMETERS: #{params} *******"
  end

  #// returns a single posting object
  def show
  end

end



