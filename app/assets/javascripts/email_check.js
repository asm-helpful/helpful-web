$(function() {
  var $name = $('#account_name');
  var $email = $('#account_email');
  var $formGroup = $email.closest('.form-group');

  var toSlug = function(name) {
    return name.toLowerCase().
      replace(/[^\w ]+/g,'').
      replace(/ +/g,'-')
  };

  var toEmail = function(slug) {
    if(!slug || slug === '') {
      return;
    }

    return [
      slug,
      '@',
      'helpful.io'
    ].join('');
  };

  var generateEmail = function() {
    var name = $name.val();
    var slug = toSlug(name);
    var email = toEmail(slug);

    if(email !== $email.val()) {
      $email.val(email);
      validateEmail();
    }
  };

  var feedbackIconClass = function(feedback) {
    switch(feedback) {
      case 'success':
        return 'geomicon-check';
      case 'loading':
        return 'geomicon-sync';
      case 'error':
        return 'geomicon-alert';
    }
  };

  var hideFeedback = function($formGroup) {
    $formGroup.removeClass('has-feedback');

    $formGroup.removeClass('has-success');
    $formGroup.removeClass('has-loading');
    $formGroup.removeClass('has-error');

    $('.form-control-feedback', $formGroup).hide();
  };

  var showFeedback = function($formGroup, feedback) {
    hideFeedback($formGroup);
    $formGroup.addClass('has-feedback');
    $formGroup.addClass('has-' + feedback);
    $('.' + feedbackIconClass(feedback), $formGroup).show();
  };

  var timer;

  var validateEmail = function() {
    clearTimeout(timer);

    var $formGroup = $email.closest('.form-group');

    if($email.val() === '') {
      hideFeedback($formGroup);
      return;
    }

    showFeedback($formGroup, 'loading');

    timer = setTimeout(function() {
      var email = $email.val();
      var slug = email.toLowerCase().replace('@helpful.io', '');

      $.get('/account_emails/' + slug + '.json').done(function() {
        showFeedback($formGroup, 'error');
      }).error(function(xhr) {
        if(xhr.status === 404) {
          showFeedback($formGroup, 'success');
        } else {
          hideFeedback($formGroup);
        }
      });
    }, 600);
  };

  $name.keyup(function(event) {
    generateEmail();
  });

  $email.keyup(function(event) {
    validateEmail();
  });
});
