

//
//  The postings javascript handles two types of ajax actions:
//  (1) retrieving the view for postings (by type) and rendering within page
//  (2) allowing users to submit postings (by type)
//


// PostingApp object, with postingType
function PostingApp(saintId, postingType) {
  this.saintId = saintId;
  this.postingType = postingType;
}

// Initializer
PostingApp.prototype.init = function() {
  //  Retrieve just the first page of content
  this.getContent();
}

// Retrieve content for a given page
PostingApp.prototype.getContent = function(pageNum) {
  var resultsContainerSelector = '#posting-content-' + this.postingType
  var paObj = this;
  $.get(this.getIndexUrl(pageNum), function(data) {
    $(resultsContainerSelector).html(data);
    paObj.bindPageLinks();
  });
}

// Bind page links to new content (pagination)
PostingApp.prototype.bindPageLinks = function() {
  //  Bind listeners to each link in the paginator for navigation
  var paObj = this;
  $('.page-link').click(function() {
    var pNum = $(this).attr('data-id');
    paObj.getContent(pNum);
  });
}

// Handles the save functionality
PostingApp.prototype.save = function() {
}

// Handles the cancel functionality
PostingApp.prototype.cancel = function() {
}


//  Utility Methods
//  Get URL for index
PostingApp.prototype.getIndexUrl = function(pageNum) {
  indexUrl = '/saints/' + this.saintId + '/postings?type=' + this.postingType;
  if (pageNum != null) { indexUrl += '&page=' + pageNum; }
  return indexUrl;
}




