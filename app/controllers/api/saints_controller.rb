
##
#  Saint Search & Dimension API
#  TODO: need to devise a way to secure API (need to generate a key or something)
#
class Api::SaintsController < Api::ApiController

  ##
  #  Performs a saint search
  #   Takes two parameters:
  #     q = any full text search question
  #     attributes = a comma-separated list of selected attributes
  def search

    #  Retrieve search parameters
    q = params[:q]
    attributes = params[:attributes]
    attrib_list = attributes.nil? ? [] : attributes.split(',')

    # Performs search - returns an object of type Search::SaintResult
    search_res = Search::Saint.search(q, attrib_list)

    # Attributes and categories
    # TODO: explore caching of these properties to avoid unnecesary database lookup
    attrib_categories = AttribCategory.all_visible
    attribs_all = AttribCategory.map_attrib_cat_content(true)

    #  Construct search results
    res = {
        :attribute_hierarchy => attrib_hierarchy_current(attrib_categories, attribs_all, search_res.attrib_map),
        :search_results => search_res.results
    }

    render :json => res
  end

  ##
  #  Retrieves the entire visible attribute hierarchy
  #  These are organized by attribute categories
  def attributes

    # Retrieve attribs and categories
    # TODO: explore caching of these properties to aviod unnecessary database lookups
    attrib_categories = AttribCategory.all_visible
    attribs_all = AttribCategory.map_attrib_cat_content(true)

    #  Construct response hash from attributes and attribute categories
    #  Will be converted into JSON
    res = {:attribute_hierarchy => attrib_hierarchy(attrib_categories, attribs_all)}

    #  Return this json data
    render :json => res
  end

  ##
  #  Returns saint details, given a list of saint identifiers
  def details
    saint_id_list = params[:saint_ids]

  end


  private

  ##
  #  Render Attribute Hierarchy
  def attrib_hierarchy(attrib_categories = [], attribs_mapped = {})
    #  List of categories, each containing list of attributes
    category_list = []
    attrib_categories.each do |category|
      attribs_for_category = attribs_mapped[category.code]
      attrib_list = []
      attribs_for_category.each do |attrib|
        attrib_list << {:code => attrib.code, :name => attrib.name }
      end
      category_list << {:code => category.code, :name => category.name, :attributes => attrib_list}
    end
    {:categories => category_list}
  end

  ##
  #  Render Attribute Hierarchy, but only the attributes that exist in attrib_counts
  def attrib_hierarchy_current(attrib_categories = [], attribs_mapped = {}, attrib_counts = {})
    category_list = []
    attrib_categories.each do |category|
      attribs_for_category = attribs_mapped[category.code]
      attrib_list = []
      attribs_for_category.each do |attrib|
        if (attrib_counts.has_key?(attrib.code))
          attrib_list << {:code => attrib.code, :name => attrib.name, :count => attrib_counts[attrib.code]}
        end
      end
      # Add to category list only if there are any attribs
      if (attrib_list.present?)
        category_list << {:code => category.code, :name => category.name, :attributes => attrib_list}
      end
    end
    {:categories => category_list}
  end

end

