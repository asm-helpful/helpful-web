$(function() {
  var $name = $('#account_name');
  var $email = $('#account_email');

  var toSlug = function(name) {
    return name.toLowerCase().
      replace(/[^\w ]+/g,'').
      replace(/ +/g,'-')
  }

  var toEmail = function(slug) {
    if(!slug || slug === '') {
      return;
    }

    return [
      slug,
      '@',
      'helpful.io'
    ].join('');
  }

  $name.keyup(function() {
    var name = $name.val();
    var slug = toSlug(name);
    var email = toEmail(slug);
    $email.val(email);
  });
});
