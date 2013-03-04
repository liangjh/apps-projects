
/*
 * Saintstir "Explore" Screen
 * This is the javascript functionality for the server-side-centric implementation of the
 * Saintstir explore / filter / search screen
 */

ExploreSSApp = function() {
  this._attributes = new Array();
  this._searchQ = null;
  this._container = null;
  this._tiles = null;
}

ExploreSSApp.prototype.init = function(searchQ, attributes) {
  this._searchQ = searchQ;
  this._attributes = attributes;
  this.initContainer();
  this.bindFilters();
  this.bindBreadcrumbs();
}

// Initialize content container
// Generate element list, remove and insert into content container
ExploreSSApp.prototype.initContainer = function() {
  this._tiles = $('#isotope_content .element');
  this._container = $('#isotope_content').isotope();
  this._container.isotope('remove', this._tiles);
  this._container.isotope('insert', this._tiles);
}

ExploreSSApp.prototype.bindFilters = function() {
  var _this = this;
  // Bind search and filters
  $('#discrete_filters a.filter').click(function() {
    var selectedFilter = $(this).attr('data-filter');
    _this._attributes.push(selectedFilter);
    // Submit to server
    _this.search();
  });
}

ExploreSSApp.prototype.bindBreadcrumbs = function() {
  var _this = this;
  $('#bread_crumbs a').click(function() {
    var filterVal = $(this).attr('data-filter');
    // Use an underscore lib to reject elements from an array
    _this._attributes = _.without(_this._attributes, filterVal);
    _this.search();
  });
}

// This submits the search to the server
// Set the attributes form element on the page, submit to server
ExploreSSApp.prototype.search = function() {
  //  Create a comma-delimited string representing values
  var attribVal = this._attributes.join(',');
  $('#attributes').val(attribVal);
  $('#saint_search').get(0).submit();
}


