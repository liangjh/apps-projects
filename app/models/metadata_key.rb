
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
    return "SHORT" == meta_type
  end

  def is_long?
    return "LONG" == meta_type
  end

  scope :all_visible, lambda { {:conditions => {:visible => true}}}
  scope :by_metadata_key_code, lambda {|metadata_key_code| {:conditions => {:code => metadata_key_code}} }
  scope :for_metadata_value, lambda {|metadata_value| {:conditions => {:id => metadata_value.metadata_key_id, :visible => true}}}

end
