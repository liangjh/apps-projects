
#
#  Rudimentary 'like' functionality for postings
#  Columns:
#     - id
#     - user_id
#     - posting_id
#

class UserPostingLike < ActiveRecord::Base


  class << self

    # Returns true if a user has liked a posting
    def has_vote_for?(user, posting)
      (self.where(:user_id => user.id, :posting_id => posting.id).count > 0)
    end

    def create_from_user_posting(user, posting)
      self.create(:user_id => user.id, :posting_id => posting.id)
    end

    def all_postings_for_user(user)
      posting_ids = self.select(:posting_id).find_all_by_user_id(user.id).map { |x| x.posting_id }
      Posting.find(posting_ids) if (posting_ids.present?)
    end

  end

end

