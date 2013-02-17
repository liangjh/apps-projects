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


  ##
  #  Returns a map of remaining attributes, with counts
  def attrib_map
    # TODO: maybe there's a better way to reference current-tags and standardize it
    attr_map = @result.facets['current-tags']['terms'].inject({}) do |accum_hash, elem|
      accum_hash[elem['term']] = elem['count']
      accum_hash
    end
    attr_map
  end

  ##
  # Returns a list of remaining attributes with count
  def attrib_list
    attr_list = @result.facets['current_tags']['terms'].inject([]) do |accum_list, elem|
      accum_list << [elem['term'], elem['count']]
      accum_list
    end
    attr_list
  end


  def results_raw
    @result
  end


  ##
  #  Returns a array of results (array of hashes)
  #  Accepts a block from caller to add rendering attributes
  def results(&rendering_attribute_block)
    result_array = @result.inject([]) do |accum_array, element|
      accum_array <<  {
        :id => element.id,
        :symbol => element.symbol,
        :name => element.name,
        :attributes => element.attribs
      }
      # Add any additional properties, if necessary
      accum_array
    end

    ##
    # Adding rendering attributes
    # Since search results dont have knowledge of any add'l rendering attributes
    # added by the caller, allow caller to inject any rendering logic into the results
    if (rendering_attribute_block.present?)
      result_array.each do |res|
        render_attribs = rendering_attribute_block.call(res[:attributes])
        res[:render_attributes] = render_attribs
      end
    end
    result_array
  end



end
