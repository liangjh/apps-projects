require 'm_diffable'

##
# Join table between saints and attributes
# This allows a many-to-many association between the two tables
# We create our own save / resolution constructs because the relationship is a bit too
# complex to resolve simply via equals
#
#  -- COLUMNS --
#   id, saint_id (fk: saints.di), attrib_id (fk: attribs.id)
#


class SaintAttrib < ActiveRecord::Base

  # Mixins
  include MDiffable

  # Associations
  belongs_to :saint
  belongs_to :attrib

  # Retrieve associated saint and attrib
  scope :by_saint_and_attrib, lambda {|saint, attrib| {:conditions => {:saint_id => saint, :attrib_id => attrib }}}
  scope :by_saint_and_attrib_category, lambda { |saint, category| {:conditions => {:saint_id => saint, :attrib_id => Attrib.by_category(category)}}}

  ##
  #  Constructs an object, but does not save
  def self.construct_saint_attrib(saint, attrib)
    if (saint.nil? || attrib.nil?)
      return nil
    end
    SaintAttrib.new({:saint_id => saint.id, :attrib_id => attrib.id})
  end

  def self.delete_for_saint(saint)
    all_attribs = SaintAttrib.where(:saint_id => saint.id)
    all_attribs.each { |at| at.destroy }
  end

  ##
  #  Saves a list of MetadataValue objects (for a single metadata value / type)
  def self.save_mappings(saint, attrib_category, saint_attribs = [])
    if (saint_attribs == nil || saint_attribs.empty?)
      return []
    end

    all_current = SaintAttrib.by_saint_and_attrib_category(saint, attrib_category)
    sattribs_to_add = diff_op(saint_attribs, all_current, false)
    sattribs_to_remove = diff_op(all_current, saint_attribs, false)

    sattribs_to_add.each { |add| add.save! }
    sattribs_to_remove.each { |remove| remove.destroy }

  end

  ##
  #  Returns a list of unique attribute ids that are actually used
  def self.attrib_ids_in_use
    self.all.map(&:attrib_id).uniq.sort
  end

  ##
  #  Saint attribute
  def equivalent?(saint_attrib)
    (saint_attrib != nil &&
     self.saint_id == saint_attrib.saint_id && self.attrib_id == saint_attrib.attrib_id)
  end




end
