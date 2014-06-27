class PersonSerializer < BaseSerializer
  attributes :email, :gravatar_url, :initials, :name, :nickname, :agent

  def nickname
    Nicknamer.new(object).nickname
  end

  def gravatar_url
    id = Digest::MD5::hexdigest(object.email).downcase
    "https://secure.gravatar.com/avatar/#{id}.png?s=60&d=mm"
  end

  def agent
    object.user.present?
  end
end
