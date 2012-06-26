

#//
#//  The posting model is the main model that represents the two types of user postings
#//  on saintstir:  (1) the prayer, and (2) the story.
#//
#//  -- COLUMNS --
#//   id, content, status, posting_type, votes, user_id, saint_id
#//      where status in ('pending','reject','accept')
#//      where posting_type in ('prayer','story')
#//

class Posting < ActiveRecord::Base

  #// Constants
  TYPE_PRAYER = "prayer"
  TYPE_STORY = "story"
  STATUS_PENDING = "pending"
  STATUS_REJECT = "reject"
  STATUS_ACCEPT = "accept"

  #// Associations
  belongs_to :user
  belongs_to :saint

  #// Scopes etc
  scope :by_prayer, where(:posting_type => TYPE_PRAYER)
  scope :by_story, where(:posting_type => TYPE_STORY)
  scope :by_status_accept, where(:status => STATUS_ACCEPT)
  scope :by_saint, lambda { |saint| where(:saint_id => saint.id) }
  scope :by_saint_id, lambda { |saint_id| where(:saint_id => saint_id) }

  def to_json(options={})
    super(options.merge(:only => [:id, :content, :saint_id, :user_id]))
  end

end





