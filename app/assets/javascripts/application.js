//= require jquery
//= require jquery_ujs
//= require pusher

$(document).ready(function() {

  // Column Wrappers should be the height of the window.
  // TODO Handle window resizes
  // FIXME Investigate using the CSS3 flow properties so we don't need to us JS.
  $('.column-wrapper').height(window.innerHeight);

});
