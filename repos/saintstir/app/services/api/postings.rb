
##
#  Posting functionality
#  The posting API defines the available actions on a posting
#  This will be utilized by the saintstir core site as well as the saintstir API
#
module Api

  module Postings

    include Api::Base

    #  -- Default posting cardinality and sort orders --
    POSTINGS_PER_PAGE = 5
    SORT_BY_POPULAR = 'popular'
    SORT_BY_DATE = 'date'

    ##
    #  Retrieves postings, by a given page and a sort order
    #  (or defaults to first page if none given)
    def postings_list(options)
      @saint_id = options[:saint_id]
      @page = options[:page].nil? ? 1 : options[:page]
      @sort_by = options[:sort_by].nil? ? SORT_BY_DATE : options[:sort_by]
      @per_page = options[:per_page] || POSTINGS_PER_PAGE
      @posting_id = options[:posting_id]  #  in this case, we want to return a single posting

      # Posting ID provided - in this case, return only the posting requested
      @postings = []
      if (@posting_id)
        posting = Posting.find_by_id_and_saint_id(@posting_id, @saint_id)
        @postings << posting if (posting.present?)
      end

      # If posting ID not provided, or posting not found, then retrieve via the normal channels
      if (@postings.empty?)
        if (@sort_by == SORT_BY_POPULAR)
          @postings = Posting.by_saint_id(@saint_id).by_visible_status.includes(:user).sort_by_popular.page(@page).per(@per_page)
        else
          @postings = Posting.by_saint_id(@saint_id).by_visible_status.includes(:user).sort_by_create.page(@page).per(@per_page)
        end
      end

    end

    ##
    #  Retrieves postings, by a posting id, and sets that as the result list
    def posting_by_id(options)
      posting = Posting.find(options[:posting_id])
      @postings = []
      @postings << posting
    end

    ##
    #  Given parameters, creates a posting, and saves to database if valid
    def posting_create(user, options)
      content = options[:posting_data]
      anonymous = options[:anonymous]
      posting = Posting.new(:status => Posting::STATUS_ACCEPT,
                            :anonymous => ('true' == anonymous),
                            :user_id => user.id, :saint_id => options[:saint_id], :content => content)

      posting.save if (posting.valid?)
      posting
    end

    ##
    #  Submits a 'like' on a posting
    def posting_like(user, options)

      posting_id = params[:id]
      saint_id = params[:saint_id]

      if (posting_id)
        posting = Posting.find(posting_id.to_i)
        if (!posting.is_liked_by_user?(current_user))
          # Add 'like' entry to user_posting_likes model
          UserPostingLike.create_from_user_posting(current_user, posting)
          posting.increment_vote
          posting.save!
        end
      end

      #  if posting was found, then we assume success
      posting_id.present?
    end

    ##
    #  Flags a posting as inappropriate
    def posting_flag(options)
      posting_id = params[:id]
      saint_id = params[:saint_id]
      if (posting_id)
        posting = Posting.find(posting_id.to_i)
        posting.update_attribute(:status, Posting::STATUS_PENDING)
      end
      posting_id.present?  # return true if posting found (appropriately flagged)
    end

  end

end



