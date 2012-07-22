
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
    def has_vote_for?(user, profile)
      (self.where(:user_id => user.id, :profile_id => profile.id).count > 0)
    end

  end

end

