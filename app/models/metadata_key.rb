
#//
#// MetadataKeys represents a particular field that can be specified
#// by an editor for a given saint
#//
#//  -- COLUMNS --
#//  id, code, name, description, meta_type
#//


class MetadataKey < ActiveRecord::Base

  #// Associations
  has_many :metadata_values
  has_many :saints, :through => :metadata_values

  #//  All query scopes
  scope :all_visible, lambda { {:conditions => {:visible => true}}}
  scope :by_metadata_key_code, lambda {|metadata_key_code| {:conditions => {:code => metadata_key_code}} }
  scope :for_metadata_value, lambda {|metadata_value| {:conditions => {:id => metadata_value.metadata_key_id, :visible => true}}}

  #// All available columns, implemented as constants / enum
  NAME = "name"
  NICKNAME = "nickname"
  BORN = "born"
  DIED = "died"
  FEASTDAY = "feastday"
  MODERNDAYCOUNTRY = "moderndaycountry"
  SPECIFICGEOPERIOD = "specificgeoperiod"
  PATRONAGE = "patronage"
  OCCUPATION = "occupation"
  BIOGRAPHY = "biography"
  QUOTES = "quotes"
  NOVENASPRAYERS = "novenasprayers"
  CANON_YEAR = "canon_year"
  FLICKR_PROFILE = "flickr_profile"
  FLICKR_SET = "flickr_set"


  #//  Map of metadata keys, by code {metadata_key_code => metadata_key}
  #//  Memoize for efficiency
  def self.map_metadata_key_by_code
    @metadata_key_by_code_map ||= self.all.inject({}) { |h,e| h[e.code] = e; h }
  end

  #//  Map of metadata keys, by id {metadata_key_id => metadata_key}
  #//  Memoize for efficiency
  def self.map_metadata_key_by_id
    @metadata_key_by_id_map ||= self.all.inject({}) { |h,e| h[e.id] = e; h }
  end

  def is_short?
    ("SHORT" == meta_type)
  end

  def is_long?
    ("LONG" == meta_type)
  end


end
