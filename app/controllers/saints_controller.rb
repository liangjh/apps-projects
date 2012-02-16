
#//
#// Saint Editor Module
#// This set of functionality is complicated - editor interface for saints.
#// Because of the number of different models that we're dealing with plus the number of dimensions (attrib+metadata)
#// there is quite a bit of processing logic here.
#//
#//

class SaintsController < ApplicationController
  around_filter :wrap_in_transaction, :only => [:create, :update, :destroy]
  before_filter :load_dimensional_data


  # Display list of available saints
  # GET /saints
  def index
    @saints = Saint.all
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
    redirect_to saints_path, :notice => "Successfully created new saint: #{@saint.symbol}"
  end

  # Updates an existing saint (form submit)
  # PUT /saints/1
  def update
    load_saint_data
    save_saint(false)
    redirect_to saints_path, :notice => "Successfully updated saint: #{@saint.symbol}"
  end

  # Disable deletions for now
  # DELETE /saints/1
  def destroy
    @saint = Saint.find(params[:id])
    MetadataValue.delete_for_saint(@saint)
    SaintAttrib.delete_for_saint(@saint)
    @saint.destroy
    redirect_to saints_url, :notice => "Successfully deleted saint: #{@saint.symbol}"
  end



  #// --- Helper methods ---

  #// Saves the saint into database
  def save_saint(is_new)

    #// Save Attributes
    @attrib_categories.each do |k,v|
      save_attrib_mappings(k, v.multi)
    end

    #// Save Metadata
    @meta_keys.each do |k,v|
      save_meta_values(k)
    end

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
    @attrib_categories = AttribCategory.all.inject({}) { |h,e| h[e.code] = e; h}
    #// Hash of Array of attributes, for each category, keyed by: category code
    @attrib_by_category = AttribCategory.all.inject({}) { |h,e| h[e.code] = Attrib.by_category(e); h }
    #// Get meta keys, but convert to hash for fast lookup in view generation
    @meta_keys = MetadataKey.all.inject({}) { |h,e| h[e.code] = e; h }
    @meta_keys_id = MetadataKey.all.inject({}) { |h,e| h[e.id] = e; h }
  end


  #// Load meta values
  def load_saint_data
    if (!(defined? @saint))
      @saint = (params[:id].nil? ? Saint.new : Saint.find(params[:id]))
    end
    #// Current saint's attributes (turn into hash)
    @attrib_saint = @saint.attribs.inject({}) { |h,e| h[e.id] = e; h }
    #// Load meta values into hash
    @meta_values = {}
    @saint.metadata_values.each do |val|
      meta_code = @meta_keys_id[val.metadata_key_id].code
      @meta_values[meta_code] = [] if (@meta_values[meta_code] == nil)
      @meta_values[meta_code] << val
    end
  end

  #//  wraps actions into a single transaction
  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end


end
