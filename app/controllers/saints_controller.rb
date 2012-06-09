require 'flickr_integration'

#//
#//  This is the core of saintstir.  The index action takes in search parameters
#//  while the show action takes
#//  Note: for p1, return all saints.  We're going to rely completely upon the
#//  isotope javascript plugin for our filtering functionality

class SaintsController < ApplicationController

  #// Return all saints, all metadata, all attributes
  #// Dump all data and render
  def index
    #// all saints
    @saints = Saint.all
    #// all metadata keys
    @meta_key_map = MetadataKey.map_metadata_key_by_code
    #// all attribute categories
    @attrib_categories = AttribCategory.all_visible
    #// all attributes, keyed by category code
    @attribs_all = AttribCategory.map_attrib_cat_content(true)
  end

  #// Return the saint passed in the ID parameter
  def show
    @saint = Saint.find(params[:id])
  end

  #// Return a blurb, which is currently rendered within a modal
  def blurb
    @saint = Saint.find(params[:id])
    render :layout => 'blankslate'
  end


end
