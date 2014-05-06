var positionPages = function() {
  $(window).resize(function() {
    $('.page-full').each(function() {
      var height = Math.max($(window).outerHeight(), 700) - 50;
      $(this).css({ height: height });
    });

    $('.page-partial').each(function() {
      var height = Math.max($(window).outerHeight() * 2/3, 700) - 50;
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
  $('[data-scroll-to-content="true"] a').click(function() {
    var target = $(this.hash);
    target = target.length ? target : $('#' + this.hash.slice(1));
    if (target.length) {
      $('html,body').animate({
        scrollTop: target.offset().top
      }, 400);
      return false;
    }
  });
};

function animateScreenshots() {
  $('.screenshot').addClass('animated bounceInUp');
  $('.screenshot img').animate({ opacity: .3 }, 100);

  var startedAnimation = false;

  $(window).scroll(function() {
     if($(window).scrollTop() > 400 && !startedAnimation) {
       startAnimation();
       startedAnimation = true;
     }
  });
}

function startAnimation() {
  setTimeout(function() { animateScreen(0) },  1000);
  setTimeout(function() { animateScreen(1) },  5000);
  setTimeout(function() { animateScreen(2) },  9000);
  setTimeout(function() { finishAnimation() }, 13000);
}

function animateScreen(index) {
  var $screenshot = $('.screenshot').eq(index);

  var $image = $screenshot.find('img');
  $('.screenshot img').not($image).animate({ opacity: .3 }, 200);
  $image.animate({ opacity: 1 }, 300).addClass('pulse');

  var $paragraph = $screenshot.find('p');
  $('.screenshot p').removeClass('focused animated flash');
  $paragraph.addClass('animated pulse focused');
}

function finishAnimation() {
  $('.screenshot img').animate({ opacity: 1 }, 800);
  $('.screenshot p').addClass('focused');
}

$(document).on('ready page:load', function() {
  positionPages();
  affixNavbar($('.navbar-placeholder'));
  scrollToContentButtons();
  animateScreenshots();
});
