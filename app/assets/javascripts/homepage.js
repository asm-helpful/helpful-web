
var positionPages = function() {
  $(window).resize(function() {
    $('.page-full').each(function() {
      var height = Math.max($(window).outerHeight(), 700) - 150;
      $(this).css({ height: height });
    });

    $('.page-partial').each(function() {
      var height = Math.max($(window).outerHeight() * 2/3, 900) - 50;
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

function animateScreenshots() {
  $('.screenshot').addClass('animated fadeInUp');
  $('.screenshot img').animate({ opacity: .3 }, 100);
  $('.screenshot p').animate({ opacity: .3 }, 100);

  var startedAnimation = false;

  $(window).scroll(function() {
     if($(window).scrollTop() > 400 && !startedAnimation) {
       startAnimation();
       startedAnimation = true;
     }
  });
}

function startAnimation() {
  setTimeout(function() { animateScreen(0) },  500);
  setTimeout(function() { animateScreen(1) },  1000);
  setTimeout(function() { animateScreen(2) },  1500);
  setTimeout(function() { finishAnimation() }, 1800);
}

function animateScreen(index) {
  var $screenshotList = $('.screenshot-list');
  var $screenshot = $('.screenshot').eq(index);

  // if($(window).width() < $screenshotList.width()) {
  //   $screenshotList.animate({ 'left': ($screenshotList.width() / 2) - $screenshot.position().left - ($screenshot.outerWidth(true) / 2) }, 400);
  // }

  var $image = $screenshot.find('img');
  //$('.screenshot img').not($image).animate({ opacity: .3 }, 200);
  $image.animate({ opacity: 1 }, 300);

  var $paragraph = $screenshot.find('p');
  //$('.screenshot p').not($paragraph).animate({ opacity: .3 }, 200);
  $paragraph.animate({ opacity: 1 }, 300);

}

function finishAnimation() {
  $('.screenshot img').animate({ opacity: 1 }, 400);
  $('.screenshot p').animate({ opacity: 1 }, 400);

  // var $screenshotList = $('.screenshot-list');

  // if($(window).width() < $screenshotList.width()) {
  //   $screenshotList.animate({ transform: 'scale(' + ($(window).width() / $screenshotList.width()) + ')' }, 800);
  // }
}


function isMobile() {
  return window.matchMedia("only screen and (max-width: 760px)").matches;
}
 
function displayDesktop() {
  new WOW().init();
  positionPages();
  affixNavbar($('.navbar-placeholder'));
  scrollToContentButtons();
  animateScreenshots();
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
 
$(document).on('ready page:load', function() {
    
  displayWindow();
 
});