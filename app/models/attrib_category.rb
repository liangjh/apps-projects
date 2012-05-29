
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
  default_scope :order => "name ASC"
  scope :all_visible, lambda { {:conditions => {:visible => true}}}
  scope :by_code, lambda {|category_code| {:conditions => {:code => category_code}}}

  #//  All categories, keyed by code  {attrib_cat_code => attrib_cat}
  def self.map_attrib_cat
    self.all.inject({}) { |h,e| h[e.code] = e; h}
  end

  #//  All attribs, keyed by cat code {attrib_cat_code => [attribs]}
  def self.map_attrib_cat_content
    self.all.inject({}) { |h,e| h[e.code] = e.attribs; h }
  end

end
