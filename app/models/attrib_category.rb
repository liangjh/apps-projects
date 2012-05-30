
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
  #//  Alternatively, we can return all attribs that are currently in use
  def self.map_attrib_cat_content(in_use = false)
    attrib_cats_by_id = self.all.inject({}) { |h,e| h[e.id] = e; h}
    attrib_list = []
    if (in_use)
      attrib_list = Attrib.find_all_by_id(SaintAttrib.attrib_ids_in_use)
    else
      attrib_list = SaintAttrib.all
    end
    attrib_map = {}
    attrib_list.each do |e|
      attrib_cat = attrib_cats_by_id[e.attrib_category_id]
      attrib_map[attrib_cat.code] = [] if (!attrib_map.has_key?(attrib_cat.code))
      attrib_map[attrib_cat.code] << e
    end
    attrib_map
  end


end
