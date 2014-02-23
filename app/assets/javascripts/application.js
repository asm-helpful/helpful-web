//= require jquery
//= require jquery_ujs
//= require bootstrap

$(document).ready(function() {

  // Column Wrappers should be the height of the window.
  // TODO Handle window resizes
  // FIXME Investigate using the CSS3 flow properties so we don't need to us JS.
  onWindowResize();
  $(window).resize(onWindowResize);

  function onWindowResize(){
    $('.column-wrapper').height(window.innerHeight);
    $('.column-subnav .list').height(window.innerHeight - ($('.column-subnav').height() - $('.column-subnav .list').height()));
  }

});
