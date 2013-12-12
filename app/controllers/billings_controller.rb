require "openssl"

class BillingsController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  skip_before_filter :verify_authenticity_token, only: [:webhook]

  def show
    @account = current_user.primary_owned_account
  end

  # Receives a user after they've returned from signing up at Chargify
  #
  # This is controlled by the "Return URL" setting for each product: http://docs.chargify.com/hosted-page-settings#return-url
  # Expects the following return URL parameters:
  # subscription_id={subscription_id}&reference={customer_reference}&product_handle={product_handle}&customer_id={customer_id}
  def return

    # This nicety will allow the dev environment to change an account to a paid account by just GET'ing this URL:
    # http://localhost:3000/billing/return?reference=REPLACE_WITH_ACCOUNT_ID&subscription_id=missing&customer_id=missing&product_handle=gold
    if !Rails.env.development?
      @account = Account.find(params[:reference])
      bp = BillingPlan.find_by_slug(params[:product_handle])

      @account.billing_status = 'active'
      @account.billing_plan   = bp
      @account.chargify_subscription_id = params[:subscription_id]
      @account.chargify_customer_id     = params[:customer_id]
      @account.save!
    else
      current_user.primary_owned_account.get_update_from_chargify!
    end

    redirect_to billing_url
  end

  # Receives POSTed webhooks from Chargify
  def webhook
    if webhook_valid?
      subscription_id = params[:payload] && (
        (params[:payload][:subscription] && params[:payload][:subscription][:id]) ||
        (params[:payload][:subscription_id])
      )

      if subscription_id
        @account = Account.find_by_chargify_subscription_id(subscription_id.to_s)
        @account.get_update_from_chargify!
      end

      render nothing: true, status: 200
    else
      render nothing: true, status: 401
    end
  end

  private

  def webhook_valid?
    OpenSSL::HMAC.hexdigest('sha256', Chargify.shared_secret, request.raw_post) == request.headers['X-Chargify-Webhook-Signature-Hmac-Sha-256']
  end
end
