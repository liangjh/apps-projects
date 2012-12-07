require 'flickr_integration'
require 'wikipedia_bio_scraper'

##
#  This is the core of saintstir.  The index action takes in search parameters
#  while the show action takes
#  Note: for p1, return all saints.  We're going to rely completely upon the
#  isotope javascript plugin for our filtering functionality
#
class SaintsController < ApplicationController
  before_filter :show_fb_like, :only => [:index, :show]
  before_filter :show_favorite_link, :only => [:show]
  before_filter :ajax_logged_in, :only => [:favorite, :unfavorite, :is_favorite]

  ##
  # Return all saints, all metadata, all attributes
  # Dump all data and render
  def index
    set_page_title("explore")
    if (!CacheManager.exist?(CacheConfig::PARTITION_SAINTS_ISOTOPE))
      #// all saints
      @saints = Saint.all_published
      #// all metadata keys
      @meta_key_map = MetadataKey.map_metadata_key_by_code
      #// all attribute categories
      @attrib_categories = AttribCategory.all_visible
      #// all attributes, keyed by category code
      @attribs_all = AttribCategory.map_attrib_cat_content(true)
    end
  end

  ##
  # Return the saint passed in the ID parameter
  def show
    @saint = Saint.find(params[:id])
    @posting_id = params[:posting_id]
    show_favorite_link # enable the favorite link
    set_page_title("#{@saint.symbol} (#{@saint.get_metadata_value(MetadataKey::NAME)})")
    #// All attribs in use
    @attribs_all = AttribCategory.map_attrib_cat_content(true)
  end

  ##
  # Return a blurb, which is currently rendered within a modal
  def blurb
    @saint_id = params[:id]
    if (!CacheManager.exist?(CacheConfig::PARTITION_SAINT_BLURB, params[:id]))
      @saint = Saint.find(@saint_id)
    end
    render :layout => false #// no layout, to avoid erb interpolation
  end

  ##
  #  Embeddable page for the featured saint - contains the main saint insignia
  def embed_featured
    symbol = Setting.by_key("saint_featured").first.value
    @saint = Saint.find_by_symbol(symbol)
    render :layout => 'clean', :template => 'saints/embed'
  end

  ##
  # Embeddable page - contains the main saint insignia
  def embed
    @saint = Saint.find(params[:id])
    render :layout => 'clean'
  end

  ##
  # Returns true/false, depending on whether this saint is a favorite
  def is_favorite
    saint_id = params[:id]
    user_id = current_user.id
    fave = Favorite.find_by_saint_id_and_user_id(saint_id, user_id)
    render :json => {'success' => true, 'is_favorite' => fave.present?, 'saint_id' => saint_id}.to_json
  end

  ##
  # Set this saint as a favorite for current user
  # This is ajax-based
  def favorite
    saint_id = params[:id]
    user_id = current_user.id
    Favorite.fave(saint_id, user_id)  # will do the right thing (create or ignore if exists)
    render :json => {'success' => true,
                     'message' => 'Great!  This saint has been added to your favorites'}.to_json
  end

  ##
  # Remove this saint as a favorite
  # This is ajax-based
  def unfavorite
    saint_id = params[:id]
    user_id = current_user.id
    Favorite.unfave(saint_id, user_id)  # will do the right thing (delete or ignore if DNE)
    render :json => {'success' => true,
                     'message' => 'Aww!  This saint has been removed from your favorites'}.to_json
  end


end
