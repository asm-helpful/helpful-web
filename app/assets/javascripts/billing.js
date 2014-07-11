var selectPlan = function($plan) {
  var slug = $plan.attr('data-plan-slug');
  var $currentPlan = $('.plan-subscribed');

  $('.plan-select-message', $currentPlan).text('Subscribe');
  $currentPlan.removeClass('plan-subscribed btn-link');

  $plan.addClass('plan-subscribed btn-link');
  $plan.children('.plan-select-message').text('Subscribed');
}

var updateSubscription = function() {
  var $form = $('#billing form');
  $.ajax({
    type: $form.attr('method'),
    url: $form.attr('action'),
    data: $form.serialize(),
    success: function () {
      var $plan = $('[data-plan-slug="' + $('[name="account[billing_plan_slug]"]').val() + '"]');
      selectPlan($plan);
    }
  });
}

$(function() {
  var stripe = StripeCheckout.configure({
    key: $('meta[name="stripe-token"]').attr('content'),
    token: function(token, args) {
      $('[name="account[stripe_token]"]').val(token.id);

      updateSubscription();
    }
  });

  $('[data-plan-subscribe="true"]').click(function(e) {
    if($(this).hasClass('plan-subscribed')) {
      e.preventDefault();
      return;
    }

    var slug = $(this).attr('data-plan-slug');
    var name = $(this).attr('data-plan-name');
    var amount = $(this).attr('data-plan-amount');

    $('[name="account[billing_plan_slug]"]').val(slug);

    stripe.open({
      name: 'Helpful',
      description: name + ' Plan (Monthly Subscription)',
      amount: amount,
      panelLabel: 'Pay {{amount}} per month',
      closed: function() { }
    });

    return false;
  });

  $('[data-plan-subscribe="false"]').click(function() {
    var slug = $(this).attr('data-plan-slug');
    $('[name="account[billing_plan_slug]"]').val(slug);

    updateSubscription();
    return false;
  });


});
