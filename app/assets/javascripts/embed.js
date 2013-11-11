// Supportly Embed JS

// When somebody with an Account includes a script tag to this file on their own
// website, it'll embed a simple web embed that posts to Supportly.
//
// It's attached to the DOM with the use of the `data-helpful` attribute:
//
//    <a href="#" data-helpful>Click me to show embed</a>
//
// TODO This script relies on jQuery being installed on the page. Future
// versions should get rid of that requirement so more people can install it.
//
(function($) {
  var HelpfulEmbed, EmbedHTML, embed;

  // Hack until we figure out how to get the HTML cleanly into this file.
  EmbedHTML = $('#helpful-embed-html').html();

  // HelpfulEmbed Class
  HelpfulEmbed = function() {
    this.el = $('<div></div>').hide().html(EmbedHTML).appendTo(document.body);
  }

  // Opens the embed on top of an element
  HelpfulEmbed.prototype.open = function(target) {
    var $target, targetOffset, targetOffsetBottom;

    $target = $(target);
    targetOffset = $target.offset();

    targetOffsetBottom = window.innerHeight - targetOffset.top;

    this.el.css({
      bottom:  targetOffsetBottom,
      left: targetOffset.left,
      position: 'absolute'
    });

    this.el.show();
  }

  // Closes the embed popup at the target
  HelpfulEmbed.prototype.close = function(target) {
    this.el.hide();
  }

  // Toggles the opening and closing of a popup
  HelpfulEmbed.prototype.toggle = function(target) {
    if(!this.el.is(':visible')) {
      this.open(target);
    } else {
      this.close(target);
    }
  }

  // TODO This should be store in the DOM on the target element. That will allow
  // multiple popups to exist on the page. At the moment there's only a singular
  // popup.
  embed = new HelpfulEmbed();

  // Binds the HelpfulEmbed class to the calling elements.
  $('[data-helpful]').on('click.helpful', function(e) {
    e.preventDefault();
    embed.toggle(e.target);
    return true;
  });

})(jQuery);
