module AvatarHelper

  def avatar_default(person)
    avatar(person, 30, :thumb, 'avatar-default')
  end

  # Public: View helper to provide an avatar div & img for a given user.
  #
  # person       - a Person or User object. Must have an email method.
  #
  # size         - the non-retina size of the avatar
  #
  # version      - the uploader version, see avatar_uploader.rb
  #
  # html_classes - optional extra html classes. Typically `avatar-` variations.
  #
  # Returns a img tag wraped in a div with the class of avatar.
  def avatar(person, size, version, *html_classes)
    return unless person

    content_tag(:div, class: ['avatar', *html_classes]) do
      [avatar_initials(person, size), avatar_image(person, size, version)].reduce(:+)
    end
  end

  def avatar_initials(person, size)
    content_tag(:div, '', class: 'avatar-initials', style: "#{avatar_style_constraints(size)}; display: none;")
  end

  def avatar_image(person, size, version)
    image_tag(avatar_path(person, size, version), width: size, height: size, onerror: 'toggleAvatar(this)')
  end

  def avatar_path(person, size, version)
    person.avatar.try(version).present? ? person.avatar.send(version) : gravatar_url(person.email, size)
  end

  def avatar_style_constraints(size)
    ['width', 'height', 'line-height'].map { |property| "#{property}: #{size}px" }.join('; ')
  end

  # Internal: Helper to provide the gravatar_url for a given person.
  #
  # person - a Person or User object. Must have an email method.
  #
  # Returns a url to the PNG of the user's gravatar.
  def gravatar_url(email, size)
    id = gravatar_id(email)
    "https://secure.gravatar.com/avatar/#{id}.png?s=#{size}&d=404"
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
