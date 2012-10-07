

##
#  The my page controller contains information for a given user
#  that the user has created on saintstir - preferences, favorites, postings, etc
#

class MyPageController < ApplicationController
  before_filter :check_logged_in

  ##
  #  Retrieve all data that will be rendered by this page
  def show

    #  Get all saints that this user has favorited
    @favorite_saints = current_user.saints
    #  Get all postings that this user has written
    @user_postings = current_user.postings.order(:created_at).reverse_order
    #  Get all postings that this user has liked
    # @liked_postings = UserPostingLike.all_postings_for_user(current_user)

  end


end

