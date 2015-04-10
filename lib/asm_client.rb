class AsmClient
  def post(url, payload = {})
    request :post, url, payload
  end

  def request(method, url, body = {})
    resp = connection.send(method) do |req|
      req.url url
      req.headers['Authorization'] = "Token token=#{ENV['ASM_API_TOKEN']}"
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end

    log = ['  ', method, url, body.inspect, "[#{resp.status}]"]
    if !resp.success?
      log << resp.body.inspect
    end
    Rails.logger.info log.join(' ')

    JSON.load(resp.body)
  end

  def connection
    Faraday.new(url: "#{ENV['ASM_API_URL']}") do |faraday|
      faraday.adapter  :net_http
    end
  end

end
