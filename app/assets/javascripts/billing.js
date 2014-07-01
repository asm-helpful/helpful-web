var selectPlan = function($plan) {
  var slug = $plan.attr('data-plan-slug');

  $('.plan-select').removeClass('btn-success');
  $('.plan-select-message').text('Subscribe');

  $plan.addClass('btn-success');
  $plan.children('.plan-select-message').text('Subscribed');
  $('[name="account[billing_plan_slug]"]').val(slug);
}

$(function() {
  var stripe = StripeCheckout.configure({
    key: $('meta[name="stripe-token"]').attr('content'),
    token: function(token, args) {
      $('[name="account[stripe_token]"]').val(token.id);
    }
  });

  $('[data-plan-subscribe="true"]').click(function() {
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
