

//
//  This object encapsulates all of the functionality
//  in the saint explore page.  We're trying to extract
//  all of the client-side logic out of the core page
//


ExploreApp = function() {
  // Instance vars to the function
  this._container = null;
  this._filterList = new Array();
  this._currSaintId = null;
}

ExploreApp.prototype.init = function() {
  this.initContainer();
  this.initDropdowns();
  this.bindFilters();
  this.bindPopovers();
  this.bindSaintClick();
}

ExploreApp.prototype.initContainer = function() {
  this._container = $('#isotope_content');
  this._container.isotope({itemSelector: '.element'});
}

ExploreApp.prototype.initDropdowns = function() {
  $('.dropdown-toggle').dropdown();
}

ExploreApp.prototype.appendFilter = function(selector, name) {
  if ($.inArray([selector, name], this._filterList) < 0) { this._filterList.push([selector, name]); }
  this.runFilters();
}

ExploreApp.prototype.removeFilter = function(selector) {
  this._filterList = $.grep(this._filterList, function(n) { return (n[0] != selector); });
  this.runFilters();
}

ExploreApp.prototype.runFilters = function() {
  this._container.isotope({ filter: $.map(this._filterList, function(e,i) {return e[0]; }).join('')});
  this.renderBreadCrumbs();
}

ExploreApp.prototype.renderBreadCrumbs = function() {
  var crumblist = new Array();
  $.each(this._filterList, function(i,v) {
    if (v[0] != '*') {
      crumblist.push("<a class='btn btn-info' href='#'  data-filter='" + v[0] + "'><i class='icon-remove'/> " + v[1] + "</a>")
    }
  });
  $('#bread_crumbs').html(crumblist.join(" "));

  //  Event Binding for REMOVING FILTERS from breadcrumbs section
  var eap = this;
  $('#bread_crumbs a').click(function() {
    var selector = $(this).attr('data-filter');
    eap.removeFilter(selector);
  });
}

ExploreApp.prototype.showAll = function() {
  this._filterList = new Array();
  this._filterList.push(["*", ""]);
  this.runFilters();
}

ExploreApp.prototype.bindFilters = function() {
  //  Event Binding for ADDING FILTERS
  var eap = this;
  $('#discrete_filters a').click(function(){
    var selector = $(this).attr('data-filter');
    if (selector == undefined) { return; } // exit out, if DNE
    else if (selector == '*') { showAll(); }
    else {
      var sname = $(this).text();
      eap.appendFilter(selector, sname);
    }
  });
}

ExploreApp.prototype.bindPopovers = function() {
  $('#isotope_content .element').mouseenter(function() {
    var currElem = $(this);
    var saintId = currElem.attr('data-symbol');
    var dataContent = currElem.attr('data-content');
    if (dataContent != undefined && dataContent != null)
      {
        // data is already cached - enable on screen
        currElem.popover('show');
      }
      else
      {
        this._currSaintId = saintId;
        var eap = this;
        $.get(('/saints/' + saintId + '/blurb'),
              function(data){
                $('.popover').each(function(i,e) { $(e).popover('hide'); });
                if (saintId == eap._currSaintId) {
                  currElem.attr('data-content', data);
                  currElem.popover({content: data, delay: {show: 500, hide: 100}});
                  currElem.popover('show');
                }
              });
      }
  });

  $('#isotope_content .element').mouseleave(function() {
    this._currSaintId = null;
    $('.popover').each(function(i,e) { $(e).popover('hide'); });
  });

}

ExploreApp.prototype.bindSaintClick = function() {
  //  Direct user to saint page upon click
  $('#isotope_content .element').click(function() {
    window.location = '/saints/' + $(this).attr('data-symbol');
  });
}







