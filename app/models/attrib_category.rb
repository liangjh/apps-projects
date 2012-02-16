
#//
#// AttribCategory combine discrete attribute values into logical groupings
#// (i.e. virtues, historic periods, etc)
#//
#// -- COLUMNS --
#// id, code, name, description, visible, multi
#//


class AttribCategory < ActiveRecord::Base

  #//  Association w/ attribs
  has_many :attribs

  #//  Association w/ saints
  #//  NOTE :: is this possible?  There are two intermediate models to traverse (hold off for now)
  #//  has_many :saints, :through => :attribs

  scope :all_visible, lambda { {:conditions => {:visible => true}}}
  scope :by_code, lambda {|category_code| {:conditions => {:code => category_code}}}



end
