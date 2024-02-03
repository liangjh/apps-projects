
##
# Attribs represent discrete values in the Saintstir system that
# are associated with a given Saint.
#
# -- COLUMNS --
#   id,
#   attrib_category_id (fk: attrib_categories.id),
#   code, name, description, ord, visible
#


class Attrib < ActiveRecord::Base

  # Association with: attribute categories
  belongs_to :attrib_category

  # Association with saints through saint_attributes table
  has_many :saints, :through => :saint_attribs
  has_many :saint_attribs

  # All named scopes and custom queries
  default_scope :order => "ord ASC"
  scope :by_category, lambda { |category| {:conditions => {:attrib_category_id => category} }}
  scope :by_code, lambda { |code| {:conditions => {:code => code}}}

  class << self

    ##
    # Retrieve all attributes that belong to a saint and a category
    def by_saint_and_category(saint, category)
      all_attribs = self.by_category(category)
      saint.attribs.select { |attrib| all_attribs.include?(attrib) }
    end

    ##
    # All attributes, mapped
    def all_mapped
      Attrib.all.inject({}) do |h, attrib|
        h[attrib.code] = attrib; h
      end
    end

  end

end

