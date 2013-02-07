
#//
#//  The posting model is the main model that represents the two types of user postings
#//  on saintstir:  (1) the prayer, and (2) the story.
#//
#//  -- COLUMNS --
#//
#//   id, content, status, posting_type, votes, user_id, saint_id
#//      - where status in ('pending','reject','accept')
#//      - where posting_type in ('prayer','story')
#//

class Posting < ActiveRecord::Base

  #// Associations
  belongs_to :user
  belongs_to :saint
  has_many :user_posting_likes
  after_save :save_saint_to_index

  CONTENT_MAX_WORD_COUNT = 200
  STATUS_PENDING = "pending"  #//  this means the message has been flagged for review
  STATUS_REJECT = "reject"
  STATUS_ACCEPT = "accept"

  #// Scopes
  scope :by_visible_status, where(:status => [STATUS_ACCEPT, STATUS_PENDING])
  scope :by_saint, lambda { |saint| where(:saint_id => saint.id) }
  scope :by_saint_id, lambda { |saint_id| where(:saint_id => saint_id) }
  scope :sort_by_create, order("id DESC")
  scope :sort_by_popular, order("votes DESC")

  #// Validate existence and within set of values
  validates :content, :presence => true
  validates :saint_id, :presence => true
  validates :user_id, :presence => true
  validates :status, :inclusion => {:in => [STATUS_PENDING, STATUS_REJECT, STATUS_ACCEPT], :message => "invalid value for status"}
  validates_length_of :content, :tokenizer => lambda { |str| str.scan(/\w+/)},
              :within => 1..CONTENT_MAX_WORD_COUNT,
              :too_long => "Your posting cannot exceed #{CONTENT_MAX_WORD_COUNT} words",
              :too_short => "You must enter something to post! "

  ##
  #  Re-save the saint that this posting belongs to into the search index
  def save_saint_to_index
    saint.save_to_search_index
  end

  def is_liked_by_user?(user)
    (user_posting_likes.where(:user_id => user.id).count > 0)
  end

  #// Increment the vote by 1 (if nil, start w/ 1)
  def increment_vote
    self.votes.nil? ? 1 : self.votes += 1
  end

  #// Retain user's newlines without disrupting underlying content.
  #// <pre> is not an option since some browers will use a different font for <pre>
  #// globally replace all \n with <br/>
  def content_formatted
    content.gsub(/\n/, "<br/>") if (!content.nil?)
  end

  #// Construct a json based on the model's params
  #// (will be useful if we use backbone for this project)
  def to_json(options={})
    super(options.merge(:only => [:id, :content, :saint_id, :user_id]))
  end

end





