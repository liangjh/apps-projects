
##
#  Explore / Search Interface
#  This is the server-side centric version of the saints explore page
#
class ExploreController < ApplicationController


  ##
  #  Core search / explore functionality
  #  - search (q)
  #  - attrib filtering
  #  - save query to session
  #  - render:
  #     - grid / matrix
  #     - attribute filters / hierarchy
  #     - breadcrumbs
  def show

    # Retrieve search parameters, sync with session
    @q = sync_param_q
    @attrib_list = sync_param_attributes

    # Render default results, if search criteria not met
    if ((@q.nil? || @q.length < 3) && @attrib_list.empty?)
      return default_results("Search must be at least 3 characters long") if (@q.present? && @q.length < 3)
      return default_results
    end
    #  No errors - search
    #  Perform search, and retrieve associated saints
    Rails.logger.info "search|q=#{@q}|attributes=#{@attrib_list}"
    search_res = Search::Saint.search(@q, @attrib_list)

    #  Put results in rendering format
    @result_saints = search_res.results_saints
    @result_mapped_attribs = search_res.attrib_map

    ##
    #  Rendering attribs and categories
    #  Modify attribs and categories to only include remaining attribs (adaptive filtering)
    @attribs_all_map = Attrib.all_mapped
    @attrib_categories = AttribCategory.all_visible
    @attribs_by_category = AttribCategory.map_attrib_cat_content(true,
                            lambda { |attrib_code| @result_mapped_attribs.has_key?(attrib_code) })
    @attrib_categories = @attrib_categories.reject { |attrib_cat, value| @attribs_by_category.has_key?(attrib_cat) }
    flash[:notice] = nil
    flash[:error] = nil

  end

  ##
  # Default results, if search is invalid
  def default_results(error_message = nil)

    #  Default results for rendering
    @result_saints = default_saints
    @result_mapped_attribs = {}

    #  We always render these
    @attrib_categories = AttribCategory.all_visible
    @attribs_by_category = AttribCategory.map_attrib_cat_content(true)

    flash[:error] = error_message if (error_message.present?)
    flash[:notice] = "Hi!  Only a limited set of results are returned.  To perform a search on all of our saints, enter a valid search or use any of the filters above."
    render :action => "show"

  end

  def sync_param_q
    search_q = params[:q]
    # search_q ||= session[:q]
    # session[:q] = search_q
    search_q
  end

  def sync_param_attributes
    attrib_list = params[:attributes].present? ? params[:attributes].split(',') : []
    # attrib_list ||= session[:attributes]
    # session[:attributes] = attrib_list
    attrib_list
  end

  ##
  #  Return a limited sample of saints as default, if no search parameters passed
  #  Only the first (x) results are returned
  def default_saints
    Saint.all_published.first(40)
  end



end




