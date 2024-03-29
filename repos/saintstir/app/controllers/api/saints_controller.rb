
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

    #  Parameter error checking
    return generate_error_response(['params'], 'Required parameters missing: either q or attributes must be specified') if (q.nil? && attrib_list.empty?)
    return generate_error_response(['params'], 'Full-text search string parameter: q must be at least 3 characters long') if (q.present? && q.length < 3 && attrib_list.empty?)

    ##
    # No Errors
    # Performs search - returns an object of type Search::SaintResult
    search_res = Search::Saint.search(q, attrib_list)

    # Attributes and categories
    # TODO: explore caching of these properties to avoid unnecesary databasapp/controllers/api/saints_controller.rb
    attrib_categories = AttribCategory.all_visible
    attribs_all = AttribCategory.map_attrib_cat_content(true)

    ##
    #  RENDER SEARCH RESULTS
    #  In order to prevent the search result abstraction from having specific rendering knowledge,
    #  we pass in lambdas as arguments into the search result rendering method - for attributes and for
    #  rendering color codes

    ## Only render all attributes if the api user is a privileged user
    attrib_proc = nil
    if (@auth_user.privileged?)
      attrib_proc = Proc.new { |attrib_codes|
        all_attribs_mapped = Attrib.all_mapped
        attrib_codes.inject([]) do |accum_ar, attrib_code|
          accum_ar << {:code => attrib_code, :name => all_attribs_mapped[attrib_code].name}; accum_ar
        end
      }
    end


    rendered_results = search_res.results(
      attrib_proc,
      Proc.new { |attribs|
          {:insignia => SaintInsigniaFilter.get_insignia_by_attribs(attribs), :color => SaintInsigniaFilter.get_color_by_attribs(attribs)}
      }
    )

    ##
    #  Render JSON
    #  Return attribute hierarchy IFF the user is a privileged user
    res = {}
    res[:attribute_hierarchy] = render_attrib_hierarchy(attrib_categories, attribs_all, search_res.attrib_map, true) if (@auth_user.privileged?)
    res[:results] = rendered_results
    render_response(res)

  end

  ##
  #  Retrieves the entire visible attribute hierarchy
  #  These are organized by attribute categories
  def attributes

    # Retrieve attribs and categories
    # TODO: explore caching of these properties to aviod unnecessary database lookups
    attrib_categories = AttribCategory.all_visible
    attribs_all = AttribCategory.map_attrib_cat_content(true)

    # Render response in JSON
    res = {:attribute_hierarchy => render_attrib_hierarchy(attrib_categories, attribs_all) }
    render_response(res)
  end


  ##
  #  Retrieves all available metadata values in the saintstir database
  def metadata

    # List of metadata to render
    meta = MetadataKey.all
    meta_list = meta.inject([]) do |accum_list, mkey|
      accum_list << {:code => mkey.code, :name => mkey.name}
      accum_list
    end

    # Render results in json
    res = {:metadata => meta_list}
    render_response(res)
  end


  ##
  #  Returns saint details, given a list of saint identifiers
  #  Note: only for privileged api users
  def details

    # This api call is only for privileged api users
    return generate_error_response(["unauthorized"], "Unauthorized use of API") if (!@auth_user.privileged?)

    # Assemble a list of all saints
    symbol_list = params[:symbols].present? ? params[:symbols].split(',') : []

    # Parameter error checking
    return generate_error_response(["params"], "Required parameter missing: symbols") if (symbol_list.empty?)

    saints = Saint.where(:symbol => symbol_list)

    # Construct saints rendering
    res = {:results => render_saints(saints)}
    render_response(res)
  end


  private


  ##
  #  These are the fields we want to return in the saint details API
  #  Note that these are all short fields (long meta fields are not handled currently)
  META_FIELDS = [
    MetadataKey::NICKNAME,
    MetadataKey::BORN,
    MetadataKey::DIED,
    MetadataKey::FEASTDAY,
    MetadataKey::MODERNDAYCOUNTRY,
    MetadataKey::SPECIFICGEOPERIOD,
    MetadataKey::PATRONAGE,
    MetadataKey::OCCUPATION,
    MetadataKey::CANONYEAR
  ]

  ##
  #  This returns detailed information on a saint
  #  There are some fields that are exposed by the API and others that are reserved
  def render_saints(saints = [])

    #  Render each saint
    saint_renderings = []
    saints.each do |saint|

      # Retrieve attributes and metadata for this saint
      # TODO: is there a way to optimize instead of (N+1) craziness?
      mv_map = saint.map_metadata_values_by_code
      attribs = saint.attribs

      #  Render Metadata
      mv_rendered = META_FIELDS.inject({}) do |accum_map, mkey|
        mv_array = mv_map[mkey]
        accum_map[mkey] = mv_array.map(&:value) if (mv_array.present?)
        accum_map
      end

      # Collect rendering
      saint_data = {
        # :id => saint.id,
        :symbol => saint.symbol,
        :name => saint.get_metadata_value(MetadataKey::NAME),
        :attributes => render_attribs(attribs),
        :metadata => mv_rendered
      }

      saint_renderings << saint_data
    end

    # Return rendered hash
    saint_renderings

  end

  ##
  #  Render a list of attributes
  def render_attribs(attribs = [])
    attribs.each.inject([]) do |accum_ar, attrib|
      accum_ar << {:code => attrib.code, :name => attrib.name}
      accum_ar
    end
  end


  ##
  #  Render Attribute Hierarchy
  #  Two options:
  #   1. Render everything (this is used to retrieve all available attributes that we can query on)
  #   2. Render attribs with a count (this is used in a query that narrows down the available search space)
  def render_attrib_hierarchy(attrib_categories = [],
                              attribs_mapped = {},
                              attrib_counts = {},
                              render_only_attribs_with_counts = false)
    category_list = []
    attrib_categories.each do |category|
      attribs_for_category = attribs_mapped[category.code]
      attrib_list = []
      attribs_for_category.each do |attrib|
        if (render_only_attribs_with_counts)
          # Render only the attributes that have counts
          if (attrib_counts.has_key?(attrib.code))
            attrib_list << {:code => attrib.code, :name => attrib.name, :count => attrib_counts[attrib.code]}
          end
        else
          # Render all attributes, no counts needed
          attrib_list << {:code => attrib.code, :name => attrib.name}
        end
      end
      # Add category to category list only if there are any attribs in that category
      if (attrib_list.present?)
        category_list << {:code => category.code, :name => category.name, :attributes => attrib_list}
      end
    end
    {:categories => category_list}
  end

end

