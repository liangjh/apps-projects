
//
//  The postings javascript handles two types of ajax actions:
//  (1) retrieving the view for postings (by type) and rendering within page
//  (2) allowing users to submit postings (by type)
//


// PostingApp object, with postingType
PostingApp = function(saintId) {
  this.saintId = saintId;
  this.currentPage = 1;
}

// Initializer
PostingApp.prototype.init = function() {
  //  Retrieve just the first page of content
  this.getContent();
  this.bindFormSubmit();
  this.bindFormCancel();
}

// Retrieve content for a given page
PostingApp.prototype.getContent = function(pageNum) {
  if (pageNum != null) { this.currentPage = pageNum; }
  this.clearFormMsg();  // clear any messages from forlm
  var paObj = this;
  $.get(paObj.getServerUri(), {page: this.currentPage},
        function(data) {
          $('#posting-content').html(data);
          paObj.bindPageLinks();
          paObj.bindLikeLinks();
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

// Bind 'like' links
PostingApp.prototype.bindLikeLinks = function() {
  var paObj = this;
  $('.like-button').click(function() {
    var postId = $(this).attr('data-id');
    $.post(paObj.getLikeUri(postId), function(data) {
      if (data.success) {
        paObj.getContent(null);
      }
    });
  });
}

// Bind the form's submit button to an ajax action w/ the server-side controller
PostingApp.prototype.bindFormSubmit = function() {
  var paObj = this;
  $('#submit-posting').click(function() {
    $.post(paObj.getServerUri(),
           {posting_data: $('#posting-data').val(),
            anonymous: ($('#posting-anonymous').val() == 'true')},
              function(data) {
                if (data.success) {
                  // response was successful:  (1) close modal, (2) clear form, (3) display in flash
                  $('#submit-posting').val('');
                  $('#posting-modal').modal('hide');
                  paObj.successMsg();
                }
                else {
                  // response was failure: (1) close modal, (2) do NOT clear form, (3) display errors in flash_error
                  $('#posting-modal').modal('hide');
                  paObj.failureMsg(data.errors);
                }
              });
  });
}

// Bind form's cancel button to clear the contents of the form
PostingApp.prototype.bindFormCancel = function() {
  $('#cancel-posting').click(function() {
    $('#posting-data').val('');
  });
}

// When a posting has been successfully submitted, display a "success" message
PostingApp.prototype.successMsg = function() {
  var successMsgHtml = "<div class='alert alert-success'>Your posting has been received.  We'll notify you as soon as it has been approved.  Thanks!</div>";
  $('#action-status').html(successMsgHtml);
}

// When a posting has been submitted w/ failures, display all failure messages
PostingApp.prototype.failureMsg = function(errorArray) {
  var failureMsgHtml = "<div class='alert alert-error'>"
  failureMsgHtml += "Oops!  Your posting couldn't be submitted, because: \n";
  for (i = 0; i < errorArray.length; i++) { failureMsgHtml += errorArray[i] + ", <br/>"; }
  failureMsgHtml += "Click on 'Write on wall' above and revise - don't worry, your stuff is still there!</div>";
  $('#action-status').html(failureMsgHtml);
}

PostingApp.prototype.clearFormMsg = function() {
  $('#action-status' + this.postingType).html('');
}

// Handles the cancel functionality
// The modal binding already takes care of closing the modal window
PostingApp.prototype.cancel = function() {
  $('#posting-data').val('');
}

PostingApp.prototype.getServerUri = function() {
  return '/saints/' + this.saintId + '/postings';
}

PostingApp.prototype.getLikeUri = function(postingId) {
  return '/saints/' + this.saintId + '/like_posting/' + postingId;
}



