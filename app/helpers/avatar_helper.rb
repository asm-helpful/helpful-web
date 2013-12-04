module AvatarHelper

  # Public: View helper to provide an avatar div & img for a given user.
  #
  # person - a Person or User object. Must have an email attribute.
  #
  # size   - the non-retina size of the avatar
  #
  # Returns a img tag wraped in a div with the class of avatar.
  def avatar(person, size)
    content_tag(:div, class: 'avatar') do
      image_tag gravatar_url(person.email, size)
    end
  end

  # Internal: Helper to provide the gravatar_url for a given person.
  #
  # person - a Person or User object. Must have an email attribute.
  #
  # Returns a url to the PNG of the user's gravatar.
  def gravatar_url(email, size)
    id = gravatar_id(email)
    "https://secure.gravatar.com/avatar/#{id}.png?s=#{size}"
  end

  def gravatar_id(email)
    Digest::MD5::hexdigest(email).downcase
  end

end
