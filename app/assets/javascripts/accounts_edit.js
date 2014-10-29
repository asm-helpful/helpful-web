$(function() {
  $('.dropdown-menu a').click(function (e) {
    $('ul.nav a[href="' + this.hash + '"]').tab('show');
  });
});