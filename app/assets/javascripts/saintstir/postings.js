
//
//  The postings javascript handles two types of ajax actions:
//  (1) retrieving the view for postings (by type) and rendering within page
//  (2) allowing users to submit postings (by type)
//


// PostingApp object, with
PostingApp = function(saintId, maxWordCount) {
  this.saintId = saintId;
  this.maxWordCount = maxWordCount;
  this.currentPage = 1;
  this.currentSortBy = 'date';
}

// Initializer
PostingApp.prototype.init = function() {
  //  Retrieve just the first page of content
  this.getContent();
  this.bindFormSubmit();
  this.bindFormCancel();
  this.bindWordCounter();
}

// Retrieve content for a given page
PostingApp.prototype.getContent = function(pageNum, sortBy) {
  if (pageNum != null) { this.currentPage = pageNum; }
  if (sortBy != null) { this.currentSortBy = sortBy; }
  this.clearActionStatus();  // clear any action status messages
  var _this = this;
  $.get(_this.getServerUri(), {page: this.currentPage, sort_by: this.currentSortBy},
        function(data) {
          $('#posting-content').html(data);
          _this.bindPageLinks();
          _this.bindSortLinks();
          _this.bindLikeLinks();
          _this.bindFlagLinks();
        });
}

// Bind pagination links
PostingApp.prototype.bindPageLinks = function() {
  //  Bind listeners to each link in the paginator for navigation
  var _this = this;
  $('.page-link').click(function() {
    _this.clearActionStatus();
    var pNum = $(this).attr('data-id');
    _this.getContent(pNum, null);
  });
}

// Bind sort order links
PostingApp.prototype.bindSortLinks = function() {
  var _this = this;
  $('.sort-order').click(function() {
    _this.clearActionStatus();
    var sortOrder = $(this).attr('data-id');
    _this.getContent(null, sortOrder);
  });
}

// Bind 'like' links
PostingApp.prototype.bindLikeLinks = function() {
  var _this = this;
  $('.like-button').click(function() {
    _this.clearActionStatus();
    var postId = $(this).attr('data-id');
    $.post(_this.getLikeUri(postId), function(data) {
      if (data.success) {
        _this.getContent(null, null);
        _this.successMsg(data.message);
      }
      else {
        _this.failureMsg(data.errors, data.message)
      }
    });
  });
}

// Bind 'flag' links
PostingApp.prototype.bindFlagLinks = function() {
  var _this = this;
  $('.flag-button').click(function() {
    _this.clearActionStatus();
    var postId = $(this).attr('data-id');
    $.post(_this.getFlagUri(postId), function(data) {
      if (data.success) {
        _this.successMsg(data.message);
      }
      else {
        _this.failureMsg(data.errors, data.message);
      }
    });
  });
}

// Bind the form's submit button to an ajax action w/ the server-side controller
PostingApp.prototype.bindFormSubmit = function() {
  var _this = this;
  $('#submit-posting').click(function() {
    $.post(_this.getServerUri(),
           {posting_data: $('#posting-data').val(),
            anonymous: ($('#posting-anonymous').is(':checked') ? true : false)},
              function(data) {
                if (data.success) {
                  // response was successful:  (1) close modal, (2) clear form, (3) display in flash
                  $('#submit-posting').val('');
                  $('#posting-modal').modal('hide');
                  _this.getContent();
                  _this.successMsg(data.message);
                }
                else {
                  // response was failure: (1) close modal, (2) do NOT clear form, (3) display errors in flash_error
                  $('#posting-modal').modal('hide');
                  _this.failureMsg(data.errors, data.message);
                }
              });
  });
}

// Bind form's cancel button to clear the contents of the form
PostingApp.prototype.bindFormCancel = function() {
  _this = this;
  $('#cancel-posting').click(function() {
    _this.clearActionStatus();
    $('#posting-data').val('');
  });
}

PostingApp.prototype.bindWordCounter = function() {
  _this = this;
  $('#posting-data').keyup(function(event) { _this.wordCounter(event, _this.maxWordCount); });
  $('#posting-data').change(function(event) { _this.wordCounter(event, _this.maxWordCount); });
  $('#cancel-posting').click(function(event) { _this.wordCounter(event, _this.maxWordCount); });
}

PostingApp.prototype.wordCounter = function(event, maxWords) {
  var wc = $('#posting-data').val().split(/[\s]+/).length;
  $('#word-count').html(wc)
  if (wc > maxWords) { $('#word-count').attr('style','color:red'); }
  else { $('#word-count').attr('style','color:black'); }
}


// When a posting has been successfully submitted, display a "success" message
PostingApp.prototype.successMsg = function(message) {
  var successMsgHtml = "<div class='alert alert-success'>" + message + "</div>";
  $('#action-status').html(successMsgHtml);
}

// When a posting has been submitted w/ failures, display all failure messages
PostingApp.prototype.failureMsg = function(errorArray, message) {
  var failureMsgHtml = "<div class='alert alert-error'>"
  for (i = 0; i < errorArray.length; i++) { failureMsgHtml += errorArray[i] + ", <br/>"; }
  if (message != undefined) { failureMsgHtml += message }
  failureMsgHtml += "</div>";
  $('#action-status').html(failureMsgHtml);
}

PostingApp.prototype.clearActionStatus = function() {
  $('#action-status').html('');
}

// Clears posting data
// The modal binding already takes care of closing the modal window
PostingApp.prototype.cancel = function() {
  $('#posting-data').val('');
}

// All URI helpers
PostingApp.prototype.getServerUri = function() {
  return '/saints/' + this.saintId + '/postings';
}
PostingApp.prototype.getLikeUri = function(postingId) {
  return '/saints/' + this.saintId + '/like_posting/' + postingId;
}
PostingApp.prototype.getFlagUri = function(postingId) {
  return '/saints/' + this.saintId + '/flag_posting/' + postingId;
}


