
#//
#// Saint is the core object in Saintstir
#// Each saint is represented by a single row in this table
#// Attributes and Metadata are all linked to this core record table
#//
#//  -- COLUMNS --
#//   id, symbol
#//


class Saint < ActiveRecord::Base

  #// Associations for Metadata
  has_many :metadata_values
  has_many :metadata_keys, :through => :metadata_values

  #// Associations for Attributes
  has_many :saint_attribs
  has_many :attribs, :through => :saint_attribs


  scope :by_symbol, lambda {|symbol| {:conditions => {:symbol => symbol}}}


  #//  Retrieve all metadata values by a metadata key
  def self.metadata_values_by_meta_key(meta_key)

  end

  #//  Last modified is the max updated_at between saint, metadata_value, and saint_attrib
  def last_modified
    mod_times = []
    mod_times << self.updated_at
    mod_times << MetadataValue.where(:saint_id => self.id).maximum(:updated_at)
    mod_times << SaintAttrib.where(:saint_id => self.id).maximum(:updated_at)
    mod_times.sort
    mod_times.last
  end


  #// Save submitted attributes - we need to resolve this with
  #// any existing attributes:  (1) create new, (2) delete not included, (3) ignore already included
  def save_attributes_for_saint(attrib_category, attribs_submitted = [])

    attribs_all_category = Attrib.by_category(attribute_category)
    attribs_saint = self.attributes.select { |attr| attribs_all_category.include?(attr)}
    attribs_to_create = attribs_submitted - attribs_saint
    attribs_to_delete = attribs_saint - attribs_submitted

    attribs_to_create.each { |new_attrib| SaintAttrib.create(:saint_id => self.id, :attrib_id => new_attrib.id) }
    attribs_to_delete.each { |del_attrib| SaintAttrib.by_saint_and_attrib(self, del_attrib).first.destroy  }

  end



end
