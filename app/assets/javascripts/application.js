//= require jquery
//= require jquery_ujs

$(document).ready(function() {

  // Column Wrappers should be the height of the window.
  // TODO Handle window resizes
  // FIXME Investigate using the CSS3 flow properties so we don't need to us JS.
  $('.column-wrapper').height(window.innerHeight);

});
//= require underscore
//= require backbone
//= require helpful
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
