
#//
#// Saint Editor Module
#// This set of functionality is complicated - editor interface for saints.
#// Because of the number of different models that we're dealing with plus the number of dimensions (attrib+metadata)
#// there is quite a bit of processing logic here.
#//
#//

class Admin::SaintsController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_super_user  #//  administrative pages only for super users
  around_filter :wrap_in_transaction, :only => [:create, :update, :destroy]
  before_filter :load_dimensional_data

  #// for pagination
  SAINTS_PER_PAGE = 20

  # Display list of available saints - we implement pagination here as well
  # GET /saints
  def index

    # Read in all params
    @page = (params[:page] || session[:saints_page] || "1")
    session[:saints_page] = @page
    @search_q = params[:search]

    #  If there is a search q, perform it; otherwise, get all w/ pagination
    if @search_q.present? && @search_q.length > 1
      @saints = Saint.search_by_name_and_symbol(@search_q)
    else
      @search_q = nil
      @saints = Saint.sort_by_symbol.page(@page).per(SAINTS_PER_PAGE)
    end

  end

  # Return form to create a new saint
  # GET /saints/new
  def new
    load_saint_data
  end

  # Return form w/ existing saint details (to edit)
  # GET /saints/1/edit
  def edit
    load_saint_data
  end

  # Creates a new saint (form submit)
  # POST /saints
  def create
    @saint = Saint.create(:symbol => params[:symbol])
    load_saint_data
    save_saint(true)
    redirect_to admin_saints_path, :notice => "Successfully created new saint: #{@saint.symbol}"
  end

  # Updates an existing saint (form submit)
  # PUT /saints/1
  def update
    load_saint_data
    save_saint(false)
    redirect_to admin_saints_path, :notice => "Successfully updated saint: #{@saint.symbol}"
  end

  # Disable deletions for now
  # DELETE /saints/1
  def destroy
    @saint = Saint.find(params[:id])
    MetadataValue.delete_for_saint(@saint)
    SaintAttrib.delete_for_saint(@saint)
    @saint.destroy
    redirect_to admin_saints_path, :notice => "Successfully deleted saint: #{@saint.symbol}"
  end



  #// --- Helper methods ---

  #// Saves the saint into database
  def save_saint(is_new)

    #// Save saint core object (symbol, publish), if modified
    if (params[:symbol] != @saint.symbol || params[:publish] != @saint.publish.to_s)
      @saint.symbol = params[:symbol]
      @saint.publish = params[:publish]
      @saint.save
    end

    #// Save Attributes
    @attrib_categories.each do |k,v|
      save_attrib_mappings(k, v.multi)
    end

    #// Save Metadata
    @meta_keys.each do |k,v|
      save_meta_values(k)
    end

    #// Save audit information
    audit = @saint.saint_edit_audits.create do |a|
      a.saint_id = @saint.id
      a.edited_by = current_user.email
      a.comment = params[:edit_comment]
    end

    #// flush cache for this saint upon save
    @saint.flush_cached_data

  end


  #// Save metadata values into databases (note, each line is its own meta
  def save_meta_values(meta_key_code)

    submitted_values = params[meta_key_code].nil? ? [] : params[meta_key_code].split("\r\n")
    meta_key = @meta_keys[meta_key_code]
    meta_values = []
    submitted_values.compact.each_with_index do |values, index|
      meta_values << MetadataValue.construct_metadata_value(@saint, meta_key, values, index)
    end
    Rails.logger.info("Saving meta for saint: #{@saint.symbol}, for key: #{meta_key_code}, values: #{submitted_values}")
    MetadataValue.save_mappings(@saint, meta_key, meta_values)

  end


  #//  For saint, saves for a single category
  def save_attrib_mappings(category_code, is_multi)
    submitted_values = params[category_code].nil? ? [] : (params[category_code].kind_of?(Array) ? params[category_code] : [] << params[category_code])
    submitted_attribs = submitted_values.map { |attr_id_str| Attrib.find(attr_id_str.to_i) }
    attrib_cat = @attrib_categories[category_code]
    saint_attribs = []
    submitted_attribs.each do |attrib|
      saint_attribs << SaintAttrib.construct_saint_attrib(@saint, attrib)
    end
    Rails.logger.info("Saving attrib for saint: #{@saint.symbol}, category: #{category_code}, attribs: #{submitted_values}")
    SaintAttrib.save_mappings(@saint, attrib_cat, saint_attribs)

  end


  #// Load attributes / categories to build saint edit form
  def load_dimensional_data
    #//  All attribute categories, keyed by: code
    @attrib_categories = AttribCategory.map_attrib_cat_by_code
    #// Hash of Array of attributes, for each category, keyed by: category code
    @attrib_by_category = AttribCategory.map_attrib_cat_content
    #// Get meta keys, but convert to hash for fast lookup in view generation
    @meta_keys = MetadataKey.map_metadata_key_by_code
    @meta_keys_id = MetadataKey.map_metadata_key_by_id
  end


  #// Load meta values
  def load_saint_data
    if (!(defined? @saint))
      @saint = (params[:id].nil? ? Saint.new : Saint.find(params[:id]))
    end
    #// Current saint's attributes (turn into hash)
    @attrib_saint = @saint.map_attribs_by_id
    #// Load meta values into hash
    @meta_values = @saint.map_metadata_values_by_code
  end

  #//  wraps actions into a single transaction
  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

end
