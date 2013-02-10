
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
    # TODO: explore caching of these properties to avoid unnecesary databasapp/controllers/api/saints_controller.rb
    attrib_categories = AttribCategory.all_visible
    attribs_all = AttribCategory.map_attrib_cat_content(true)

    #  To render insignia badges and colors, a block is passed into the
    rendered_results = search_res.results do |attribs|
      {
        :insignia => SaintInsigniaFilter.get_insignia_by_attribs(attribs),
        :color => SaintInsigniaFilter.get_color_by_attribs(attribs)
      }
    end

    #  Construct search results
    res = {
      :attribute_hierarchy => render_attrib_hierarchy(attrib_categories, attribs_all, search_res.attrib_map, true),
      :results => rendered_results
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

    # Render response in JSON
    res = {:attribute_hierarchy => render_attrib_hierarchy(attrib_categories, attribs_all) }
    render :json => res
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
    render :json => res
  end


  ##
  #  Returns saint details, given a list of saint identifiers
  def details
    # Assemble a list of all saints
    saint_id_list = params[:saint_ids].split(',')
    saints = Saint.where(:id => saint_id_list)

    # Construct saints rendering
    res = {:results => render_saints(saints)}
    render :json => res
  end


  private


  ##
  #  These are the fields we want to return in the saint details API
  META_FIELDS = [
    MetadataKey::NICKNAME,
    MetadataKey::BORN,
    MetadataKey::DIED,
    MetadataKey::FEASTDAY,
    MetadataKey::MODERNDAYCOUNTRY,
    MetadataKey::SPECIFICGEOPERIOD,
    MetadataKey::PATRONAGE,
    MetadataKey::OCCUPATION,
    MetadataKey::BIOGRAPHY,
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
        :id => saint.id,
        :symbol => saint.symbol,
        :name => saint.get_metadata_value(MetadataKey::NAME),
        :attributes => attribs.map(&:code),
        :metadata => mv_rendered
      }

      saint_renderings << saint_data
    end

    # Return rendered hash
    saint_renderings

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

