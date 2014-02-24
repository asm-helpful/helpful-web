module AvatarHelper

  def avatar_default(person)
    avatar(person, 45, 'avatar-default')
  end

  # Public: View helper to provide an avatar div & img for a given user.
  #
  # person       - a Person or User object. Must have an email method.
  #
  # size         - the non-retina size of the avatar
  #
  # html_classes - optional extra html classes. Typically `avatar-` variations.
  #
  # Returns a img tag wraped in a div with the class of avatar.
  def avatar(person, size, *html_classes)
    content_tag(:div, class: ['avatar', *html_classes]) do
      image_tag gravatar_url(person.email, size), width: size, height: size
    end
  end

  # Internal: Helper to provide the gravatar_url for a given person.
  #
  # person - a Person or User object. Must have an email method.
  #
  # Returns a url to the PNG of the user's gravatar.
  def gravatar_url(email, size)
    id = gravatar_id(email)
    "https://secure.gravatar.com/avatar/#{id}.png?s=#{size}"
  end

  # Internal: Helper that generates a gravatar id for an email
  #
  # email - a string
  #
  # Returns a string id.
  def gravatar_id(email)
    Digest::MD5::hexdigest(email).downcase
  end

end
