
/**
 *  Hovering popover functionality
 *  This contains functionality that manages the mini biographical popover
 *  when a mouse hovers over a saint tile
 */


SaintPopoverApp = function() {
  this._currSaintId = null;
}

SaintPopoverApp.prototype.init = function() {
  this.bindPopovers();
  this.bindSaintClick();
}


SaintPopoverApp.prototype.bindPopovers = function() {
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
        var _this = this;
        $.get(('/saints/' + saintId + '/blurb'),
              function(data){
                $('.popover').each(function(i,e) { $(this).popover('hide'); });
                if (saintId == _this._currSaintId) {
                  currElem.attr('data-content', data);
                  currElem.attr('data-container', 'body');
                  currElem.popover({content: data, html: true, trigger: 'hover', delay: {show: 500, hide: 100}});
                  currElem.popover('show');
                }
              });
      }
  });

  $('#isotope_content .element').mouseleave(function() {
    this._currSaintId = null;
    $('.popover').each(function(i,e) {
        $(this).popover('hide');
    });
  });

}

SaintPopoverApp.prototype.bindSaintClick = function() {
  //  Direct user to saint page upon click
  $('#isotope_content .element').click(function() {
    window.parent.location.href = '/saints/' + $(this).attr('data-symbol');
  });
}






