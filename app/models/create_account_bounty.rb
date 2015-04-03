class CreateAccountBounty
  attr_accessor :email

  def self.award(email)
    new(email).award
  end

  def initialize(email)
    self.email = email
  end

  def award
    response = HTTParty.post(url, request)
  end

  def url
    "#{host}/orgs/#{org_id}/bounties/#{bounty_number}/awards"
  end

  def request
    {
      body: body,
      headers: headers
    }
  end

  def body
    {
      email: email,
      reason: 'Signed up for Helpful'
    }.to_json
  end

  def headers
    {
      'Content-Type'  => 'application/json',
      'Accept'        => 'application/json',
      'Authorization' => "Token token=#{assembly_token}"
    }
  end

  def org_id
    'helpful'
  end

  def bounty_number
    '904'
  end

  def host
    case Rails.env
    when 'production'
      'https://api.assembly.com'
    else
      'http://api.assembly.dev:5000'
    end
  end

  def assembly_token
    ENV.fetch('ASSEMBLY_TOKEN')
  end
end
