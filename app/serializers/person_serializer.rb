class PersonSerializer < BaseSerializer
  attributes :name, :email, :nickname, :gravatar_url, :initials

  def nickname
    Nicknamer.new(object).nickname
  end

  def gravatar_url
    id = Digest::MD5::hexdigest(object.email).downcase
    "https://secure.gravatar.com/avatar/#{id}.png?s=30&d=404"
  end
end
