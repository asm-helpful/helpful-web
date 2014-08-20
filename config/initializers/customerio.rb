module Customerio
  def self.client
    Customerio::Client.new(ENV['CUSTOMERIO_SITE_ID'], ENV['CUSTOMERIO_API_KEY'])
  end
end
