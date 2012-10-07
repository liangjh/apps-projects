
##
#  Stores a 'favorite' saint (or multiple favorite saints)
#  for a given user.  Contains the following columns:
#   - user_id (fk to users.id)
#   - saint_id (fk to saints.id)
#   - created_at, updated_at
#
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :saint

  #validates_uniquess_of :saint_id, :scope => :user_id

  class << self

    #  Favorite this saint for this user if association DNE
    #  This ensures that we don't double fave
    def fave(saint_id, user_id)
      fave = Favorite.find_by_saint_id_and_user_id(saint_id, user_id)
      Favorite.create(:saint_id => saint_id, :user_id => user_id) if (fave.nil?)
    end

    #  Remove the favorite association for this user / saint combo
    def unfave(saint_id, user_id)
      fave = Favorite.find_by_saint_id_and_user_id(saint_id, user_id)
      fave.destroy if (fave.present?)
    end

    #  Returns true if this favorite exists
    def fave?(saint_id, user_id)
      fave = Favorite.find_by_saint_id_and_user_id(saint_id, user_id)
      fave.present?
    end

  end
end

