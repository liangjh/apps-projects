
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

  #// Audit informaiton
  has_many :saint_edit_audits


  scope :by_symbol, lambda {|symbol| {:conditions => {:symbol => symbol}}}

  #//  Given a meta key code, return the associated metadata_value for this saint
  def get_metadata_value(meta_key_code)
    mkey = MetadataKey.by_metadata_key_code(meta_key_code)[0]
    mvalue = nil
    metadata_values.each do |mv|
      if (mv.metadata_key_id == mkey.id)
        mvalue = mv.value if (mkey.is_short?)
        mvalue = mv.value_text if (mkey.is_long?)
        break
      end
    end
    mvalue
  end

  #//  Map of all attribs associated w/ this saint {attrib_id => attrib}
  def map_attribs
    self.attribs.inject({}) { |h,e| h[e.id] = e; h }
  end

  #//  Map of all metadata associated w/ this saint {metadata_code => metadata}
  def map_metadata_values
    meta_key_map = MetadataKey.map_metadata_key_by_id
    mv = {}
    self.metadata_values.each do |val|
      meta_key_code = meta_key_map[val.metadata_key_id].code
      mv[meta_key_code] = [] if (mv[meta_key_code] == nil)
      mv[meta_key_code] << val
    end
    mv
  end

  #//  Last modified is the max updated_at between saint, metadata_value, and saint_attrib
  def last_modified
    mod_times = []
    mod_times << self.updated_at
    mod_times << MetadataValue.where(:saint_id => self.id).maximum(:updated_at)
    mod_times << SaintAttrib.where(:saint_id => self.id).maximum(:updated_at)
    mod_times.compact.sort.last
  end


  #// Save submitted attributes - we need to resolve this with
  #// any existing attributes:  (1) create new, (2) delete not included, (3) ignore already included
  def save_attributes_for_saint(attrib_category, attribs_submitted = [])
    #// Resolve submitted w/ existing values
    attribs_all_category = Attrib.by_category(attribute_category)
    attribs_saint = self.attributes.select { |attr| attribs_all_category.include?(attr)}
    attribs_to_create = attribs_submitted - attribs_saint
    attribs_to_delete = attribs_saint - attribs_submitted
    #// Perform all creation / deletion actions
    attribs_to_create.each { |new_attrib| SaintAttrib.create(:saint_id => self.id, :attrib_id => new_attrib.id) }
    attribs_to_delete.each { |del_attrib| SaintAttrib.by_saint_and_attrib(self, del_attrib).first.destroy  }
  end






end
