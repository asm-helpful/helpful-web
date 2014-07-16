$(function() {
  var $search = $('#q');
  var $dropdown = $search.closest('.dropdown');

  var open = function() {
    $dropdown.addClass('open');
  };

  var close = function() {
    $dropdown.removeClass('open');
  };

  $search.focus(function() {
    open();
  });

  $search.blur(function() {
    setTimeout(function() {
      close();
    }, 200);
  });

  $search.keypress(function() {
    if($search.val() === '') {
      open();
    } else {
      close();
    }
  });
});
