
#//
#// MetadataKeys represents a particular field that can be specified
#// by an editor for a given saint
#//
#//  -- COLUMNS --
#//  id, code, name, description, meta_type
#//


class MetadataKey < ActiveRecord::Base

  has_many :metadata_values
  has_many :saints, :through => :metadata_values

  def is_short?
    ("SHORT" == meta_type)
  end

  def is_long?
    ("LONG" == meta_type)
  end

  scope :all_visible, lambda { {:conditions => {:visible => true}}}
  scope :by_metadata_key_code, lambda {|metadata_key_code| {:conditions => {:code => metadata_key_code}} }
  scope :for_metadata_value, lambda {|metadata_value| {:conditions => {:id => metadata_value.metadata_key_id, :visible => true}}}

  #//  map of metadata keys, by code {metadata_key_code => metadata_key}
  def self.map_metadata_key_by_code
    self.all.inject({}) { |h,e| h[e.code] = e; h }
  end

  #//  map of metadata keys, by id {metadata_key_id => metadata_key}
  def self.map_metadata_key_by_id
    self.all.inject({}) { |h,e| h[e.id] = e; h }
  end


end
