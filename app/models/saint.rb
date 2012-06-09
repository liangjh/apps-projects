
#//
#// Saint is the core object in Saintstir
#// Each saint is represented by a single row in this table
#// Attributes and Metadata are all linked to this core record table
#//
#//  -- COLUMNS --
#//   id, symbol
#//

class Saint < ActiveRecord::Base

  #// Associations
  has_many :metadata_values
  has_many :metadata_keys, :through => :metadata_values
  has_many :saint_attribs
  has_many :attribs, :through => :saint_attribs
  has_many :saint_edit_audits

  #//  Scopes
  scope :by_symbol, lambda {|symbol| {:conditions => {:symbol => symbol}}}

  #//  Given a meta key code, return the associated metadata_value for this saint
  #//  Retrieve map of all values first, then retrieve by key
  def get_metadata_value(meta_key_code)
    mv = map_metadata_values_by_code
    mv[meta_key_code][0].value if (!mv[meta_key_code].nil?)
  end

  #//  Map of all attribs associated w/ this saint {attrib_id => attrib}
  def map_attribs_by_id
    @attribs_id_map ||= self.attribs.inject({}) { |h,e| h[e.id] = e; h }
  end

  #// Map of all attributes by code {attrib_code => attrib}
  def map_attribs_by_code
    @attribs_code_map ||= self.attribs.inject({}) { |h,e| h[e.code] = e; h }
  end

  #//  Map of all metadata associated w/ this saint {metadata_key_code => metadata}
  #//  Memoize all of this for efficiency
  def map_metadata_values_by_code
    if (@metadata_values_map.nil?)
      meta_key_map = MetadataKey.map_metadata_key_by_id
      mv = {}
      self.metadata_values.each do |val|
        meta_key_code = meta_key_map[val.metadata_key_id].code
        mv[meta_key_code] = [] if (mv[meta_key_code] == nil)
        mv[meta_key_code] << val
      end
      @metadata_values_map = mv
    end
    @metadata_values_map
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
