
##
#  Attachable Properties
#
#  This allow us to bind any additional properties on to any
#  object that implements this module, even if they are not part of the class definition
#
#  Concrete use case
#  This is used to quickly bind search attributes and metadata attributes that are returned
#  in a search result.  This is an optimization to avoid having to re-retrieve this information
#  from the database
#
module AttachableProperties

  def attach_property(property, value)
    check_properties
    @properties[property] = value
  end

  def get_attached_property(property)
    check_properties
    @properties[property]
  end

  def attached_property_names
    check_properties
    @properties.keys
  end

  def check_properties
    @properties = {} if (@properties.nil?)
  end

end

