require 'tire'
require 'yajl/json_gem'

##
#  Saint Search Result Container
#  We'll need to extract the matches, merge each with saint model objects (if necessary),
#  and return any matching facets
#  The goal of this class is to abstract out elasticsearch-related structure
#
class Search::SaintResult

  ##
  #  Constructor
  def initialize(result = nil)
    @result = result
  end









end
