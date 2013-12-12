module BillingsHelper
  def chargify_signup_link(text, product_id, options = {})
    options.reverse_merge!({
                             reference: @account.id,
                             email: current_user.email,
                             organization: @account.name
                           })
    link_to text, "https://#{Chargify.subdomain}.chargify.com/h/#{product_id}/subscriptions/new?#{options.to_query}"
  end
end
