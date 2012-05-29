
#//
#//  This is the core of saintstir.  The index action takes in search parameters
#//  while the show action takes
#//  Note: for p1, return all saints.  We're going to rely completely upon the
#//  isotope javascript plugin for our filtering functionality

class SaintsController < ApplicationController

  #// Return all saints
  def index
    # load in view, since we're going to frag-cache it all
    # @saints = Saint.all
  end

  #// Return the saint passed in the ID parameter
  def show
    @saint = Saint.find(param[:id])
  end

end
