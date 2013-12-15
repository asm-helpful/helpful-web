class Chargify
  include HTTParty

  def self.subdomain
    ENV['CHARGIFY_SUBDOMAIN'] || 'helpful'
  end

  def self.api_key
    ENV['CHARGIFY_API_KEY'] || 'missing'
  end

  def self.shared_secret
    ENV['CHARGIFY_SHARED_SECRET'] || 'missing'
  end

  base_uri "https://#{subdomain}.chargify.com"
  basic_auth api_key, 'x'

  def self.subscription_id_from_customer_reference(reference)
    r = get("/customers/lookup.json", query: {reference: reference} )

    if r.success?
      customer_id = r.parsed_response['customer']['id']

      r = get("/customers/#{customer_id}/subscriptions.json")

      if r.success?
        r.parsed_response[0]['subscription']['id']
      end
    end
  end

  def self.subscription_status(subscription_id)
    r = get("/subscriptions/#{subscription_id}.json")

    if r.success?
      r.parsed_response
    end
  end

  def self.management_url(customer_id)
    r = get("/portal/customers/#{customer_id}/management_link.json")
    if r.success?
      return r.parsed_response['url'], Time.parse(r.parsed_response['new_link_available_at'])
    else
      return nil, nil
    end
  end
end
