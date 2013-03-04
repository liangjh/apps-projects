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
    @attr_map ||= @result.facets['current-tags']['terms'].inject({}) do |accum_hash, elem|
      accum_hash[elem['term']] = elem['count']
      accum_hash
    end
    @attr_map
  end

  ##
  # Returns a list of remaining attributes with count
  def attrib_list
    @attr_list ||= @result.facets['current_tags']['terms'].inject([]) do |accum_list, elem|
      accum_list << [elem['term'], elem['count']]
      accum_list
    end
    @attr_list
  end


  def results_raw
    @result
  end

  def length
    @result.nil? ? 0 : @result.length
  end

  def results_mapped
    result_map = @result.inject({}) do |accum_hash, element|
      accum_hash[element.id.to_i] = element; accum_hash
    end
    result_map
  end

  ##
  #  Return the saint ids in the results
  def results_saint_ids
    id_list = @result.map(&:id)
    id_list
  end

  ##
  #  Return the saint symbols in the results
  def results_saint_symbols
    @result.map(&:symbol)
  end

  ##
  #  Returns saint objects, with attached results from search
  #  in the exact order of the search results (ie by relevance)
  def results_saints

    #  All mapped results
    results_map = results_mapped
    #  Retrieve saint object for each result
    #  Also, attach the attributes and the saint name from the search results
    saints_map = ::Saint.where(:id => results_saint_ids).all.inject({}) do |accum_map, saint|
      saint.attach_property(:name, results_map[saint.id].name)
      saint.attach_property(:attributes, results_map[saint.id].attribs)
      accum_map[saint.id] = saint
      accum_map
    end

    #  Put into order of search.   The search returns things by relevance, whereas a query does not
    #  We enforce the search's notion of relevance in in the code block below
    saint_list = []
    results_saint_ids.each do |saint_id|
      saint_list << saints_map[saint_id.to_i]
    end
    saint_list
  end

  ##
  #  Returns a array of results (array of hashes)
  #  Accepts a block from caller to add rendering attributes
  def results(attribute_lambda = nil, rendering_properties_lambda = nil)
    result_array = @result.inject([]) do |accum_array, element|
      res_hash =  {
        # :id => element.id,
        :symbol => element.symbol,
        :name => element.name
      }

      ##
      # Custom attribute renderer
      # Use attrib lambda if its passed
      if (attribute_lambda.present?)
        res_hash[:attributes] = attribute_lambda.call(element.attribs)
      else
        res_hash[:attributes] = element.attribs
      end

      accum_array << res_hash
    end

    ##
    # Adding rendering attributes
    # Since search results dont have knowledge of any add'l rendering attributes
    # added by the caller, allow caller to inject any rendering logic into the results
    if (rendering_properties_lambda.present?)
      result_array.each do |res|
        render_attribs = rendering_properties_lambda.call(res[:attributes])
        res[:render_attributes] = render_attribs
      end
    end
    result_array
  end



end
