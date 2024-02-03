

##
#  This module performs set operations (in a, not in b, vice-versa)
#  on two collections with a custom definition of equality (in method: equivalent?)
#  Classes that use this module must implement the function equivalent?, as the default
#  impl in this module throws an exception
#
module MDiffable

  # This idiom used to invoke class methods
  module ClassMethods

    ##
    #  List diff operation --- we need to do this b/c we can't utilize our definition of equivalence in include?
    #  Gets elements in list_a but not in list_b (if add_if == true)
    #  Gets elements in list_b but not in list_a (if add_if == false)
    def diff_op(list_a, list_b, add_if)
      list_diff = []
      list_a.each do |a|
        found = false
        list_b.each do |b|
          if (a.equivalent?(b))
            found = true
            break
          end
        end
        if (found == add_if)
          list_diff << a
        end
      end
      list_diff
    end


  end

  ##
  #  This will include the class method (diff_op) into any class that mixes in this module
  def self.included(includer)
    includer.extend(ClassMethods)
  end

  ##
  #  Default impl for the instance
  #  Class mixing in MDiffable should implement this method
  def equivalent?(obj)
    throw Exception.new("Diffable#equivalent? not implemented.")
  end

end
