
var positionPages = function() {
  $(window).resize(function() {
    $('.page-full').each(function() {
      var height = Math.max($(window).outerHeight(), 700) - 150;
      $(this).css({ height: height });
    });

    $('.page-center').each(function() {
      var $child = $($(this).children()[0]);
      var top = ($(this).outerHeight() - $child.outerHeight()) / 2;
      $child.css({ 'padding-top': top });
    });

    $('.page-showcase').each(function() {
      var $child = $($(this).children()[0]);
      var left = ($(this).outerWidth() / 2) - ($child.outerWidth() / 2);
      $child.css({ 'margin-left': left });
    });
  });

  $(window).resize();
};

var affixNavbar = function($navbarPlaceholder) {
  var $navbar = $($navbarPlaceholder.children()[0]);

  $(window).scroll(function() {
    if($(window).scrollTop() > $navbarPlaceholder.offset().top) {
      $navbar.removeClass('navbar-static-top');
      $navbar.addClass('navbar-fixed-top');
    } else {
      $navbar.removeClass('navbar-fixed-top');
      $navbar.addClass('navbar-static-top');
    }
  });
};

var scrollToContentButtons = function() {
  $('[data-scroll-to-content="true"] a, #btn').click(function() {
    var $target = $(this.hash);
    $target = $target.length ? $target : $('#' + this.hash.slice(1));
    if ($target.length) {
      $('html, body').animate({
        scrollTop: $target.offset().top + ($target.height() / 2) - ($(window).height() / 2)
      }, 400);
      return false;
    }
  });
};

function isMobile() {
  return window.matchMedia("only screen and (max-width: 760px)").matches;
}
 
function displayDesktop() {
  new WOW().init();
  positionPages();
  affixNavbar($('.navbar-placeholder'));
  scrollToContentButtons();
}
 
function displayMobile() {
  $(".navbar-homepage").addClass('navbar-fixed-top');
}
 
var displayWindow = function() {
  if (isMobile()) {
    displayMobile();
  } else {
    displayDesktop();
  }
};
 
$(function() {
    
  displayWindow();
 
});
