
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

  end

end

