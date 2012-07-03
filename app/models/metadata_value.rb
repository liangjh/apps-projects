require 'm_diffable'

#//
#// Metadata values represent free-form (user-entered) values for information fields
#// on metadata (compared to Attributes, which are discrete)
#//
#// -- COLUMNS --
#//   id, saint_id (fk: saints.id), metadata_key_id (fk: metadata_keys.id)
#//   value, value_text, ord, visible, multi
#//


class MetadataValue < ActiveRecord::Base

  #//  Mixins
  include MDiffable

  #//  Associations
  belongs_to :saint
  belongs_to :metadata_key
  has_one :saint
  has_one :metadata_key

  #//  Scopes
  default_scope :order => "ord ASC"
  scope :by_saint_and_metadata_key, lambda { |saint, metadata_key| {:conditions => {:saint_id => saint, :metadata_key_id => metadata_key}} }
  scope :by_saint_symbol_and_metadata_key_code, lambda { |symbol, metadata_key_code| {:conditions => {:saint_id => Saint.by_symbol(symbol), :metadata_key_id => MetadataKey.by_metadata_key_code(metadata_key_code)}, :order => "ord ASC"}}

  #// Based on inputs, create a MetadataValue object
  def self.construct_metadata_value(saint, metadata_key, value, ord)

    if (saint == nil || metadata_key == nil || value == nil)
      nil
    else
      if (metadata_key.is_short?)
        MetadataValue.new({:saint_id => saint.id, :metadata_key_id => metadata_key.id, :value => value, :ord => ord, :visible => true})
      elsif (metadata_key.is_long?)
        MetadataValue.new({:saint_id => saint.id, :metadata_key_id => metadata_key.id, :value_text => value, :ord => ord, :visible => true})
      end
    end

  end

  def self.delete_for_saint(saint)
    all_meta = MetadataValue.where(:saint_id => saint.id)
    all_meta.each { |mt| mt.destroy }
  end

  #//  Saves a list of MetadataValue objects (for a single metadata value / type)
  def self.save_mappings(saint, metadata_key, metadata_values = [])

    if (metadata_values == nil || metadata_values.empty?)
      return []
    end

    #// All metadata values for this saint and key
    all_current_metadata_values = MetadataValue.by_saint_and_metadata_key(saint, metadata_key)
    #// All meta values to be added (in submitted but not in current)
    meta_to_add = diff_op(metadata_values, all_current_metadata_values, false)
    #// Existing meta values that need to be removed (in current but not in submitted)
    meta_to_remove = diff_op(all_current_metadata_values, metadata_values, false)

    #// Perform removal for this metadata value set
    meta_to_add.each { |add| add.save! }
    meta_to_remove.each { |remove| remove.destroy }

  end


  def equivalent?(meta_val)

    (meta_val != nil &&
     self.saint_id == meta_val.saint_id &&
     self.metadata_key_id == meta_val.metadata_key_id &&
     self.value == meta_val.value &&
     self.value_text == meta_val.value_text &&
     self.ord == meta_val.ord &&
     self.visible == meta_val.visible)

  end



end
