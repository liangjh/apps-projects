
//
//  Favorites allows a user to bookmark a saint in his/her favorites list
//

Favorites = function(saintId) {
  this.saintId = saintId;
}


Favorites.prototype.init = function() {
  this.forkFavorite();
}

Favorites.prototype.favorite = function() {
  var _this = this;
  $.post(_this.getFaveUri('favorite'), function(data) {
    if (data.success) {
      _this.successMsg(data.message);
      _this.renderFavorite();
    }
    else {
      _this.failureMsg(data.message);
    }
  });
}

Favorites.prototype.unfavorite = function() {
  var _this = this;
  $.post(_this.getFaveUri('unfavorite'), function(data) {
    if (data.success) {
      _this.successMsg(data.message);
      _this.renderNonFavorite();
    }
    else {
      _this.failureMsg(data.message);
    }
  });
}

Favorites.prototype.forkFavorite = function() {
  var _this = this;
  $.get(_this.getFaveUri('is_favorite'), function(data) {
    if (data.success) {
      if (data.is_favorite) {
        _this.renderFavorite();
      }
      else {
        _this.renderNonFavorite();
      }
    }
    else {
      _this.renderNonFavorite();
      //_this.failureMsg(data.errors, data.message);
    }
  });
}

// Get the URI to post to
Favorites.prototype.getFaveUri = function(type) {
  return ('/saints/' + this.saintId + '/' + type);
}

Favorites.prototype.successMsg = function(message) {
  var pageNotice = $('#page-notice');
  if (pageNotice && pageNotice.length > 0) {
    var successHtml = "<div class='alert alert-success'>" + message + "</span>";
    pageNotice.html(successHtml);
  }
}

// Render a failure message
Favorites.prototype.failureMsg = function(message) {
  var pageNotice = $('#page-notice');
  if (pageNotice && pageNotice.length > 0) {
    var failHtml = "<div class='alert alert-error'>" + message + "</div>";
    pageNotice.html(failHtml)
  }
}

// The saint is currently set as a favorite
Favorites.prototype.renderFavorite = function() {
  var faveLink = "" +
        "<span class='label label-favorite' style='padding:5px;'>" +
          "<a href='#' id='fave-link'>" +
            "&nbsp;&nbsp;<i class='icon-star'></i>&nbsp;&nbsp;" +
          "</a>" +
        "</span>";
  $('#favorite').html(faveLink);
  $('#favorite').tooltip({title: 'Click to toggle this saint from favorites'})

  // bind the fave link action
  var _this = this;
  $('#fave-link').click(function() {
    _this.unfavorite();
  });
}

// The saint is currently not set as a favorite
Favorites.prototype.renderNonFavorite = function() {
  var faveLink = "" +
        "<span class='label' style='padding:5px;'>" +
          "<a href='#' id='fave-link'>" +
            "&nbsp;&nbsp;<i class='icon-star-empty'></i>&nbsp;&nbsp;" +
          "</a>" +
        "</span>";
  $('#favorite').html(faveLink);
  $('#favorite').tooltip({title: 'Click to toggle this saint from favorites'});

  // bind the fave link action
  var _this = this;
  $('#fave-link').click(function() {
    _this.favorite();
  });
}



