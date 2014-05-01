var stripe = StripeCheckout.configure({
  key: '<%= ENV['STRIPE_PUBLISHABLE_KEY'] %>',
  token: function(token, args) {
    $('[name="account[stripe_token]"]').val(token.id);
  }
});

var selectPlan = function($plan) {
  $('.plan-select').removeClass('btn-selected');
  $('.plan-select-message').text('Subscribe');

  $plan.addClass('btn-selected');
  $plan.children('.plan-select-message').text('Subscribed');
}

$(document).on('ready page:load', function() {
  $('[data-plan-subscribe="true"').click(function() {
    var slug = $(this).attr('data-plan-slug');
    var name = $(this).attr('data-plan-name');
    var amount = $(this).attr('data-plan-amount');

    stripe.open({
      name: 'Helpful',
      description: name + ' Plan (Monthly Subscription)',
      amount: amount,
      panelLabel: 'Pay {{amount}} per month',
      closed: function() {
        var $plan = $('[data-plan-slug="' + slug + '"]');
        selectPlan($plan);
      }
    });

    return false;
  });

  $('[data-plan-subscribe="false"]').click(function() {
    selectPlan($(this));
    return false;
  });
});
