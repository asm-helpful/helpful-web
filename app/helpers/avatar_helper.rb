module AvatarHelper
  def avatar_default(person)
    avatar(person, 30, 'avatar')
  end

  def avatar(person, size, *html_classes)
    image_tag(avatar_path(person, size), size: size, class: html_classes)
  end

  def avatar_path(person, size)
    person.avatar.try(:thumb).present? ? person.avatar.thumb : gravatar_url(person.email, size)
  end

  def gravatar_url(email, size)
    id = gravatar_id(email)
    retina_size = size * 2
    "https://secure.gravatar.com/avatar/#{id}.png?s=#{retina_size}&d=404"
  end

  def gravatar_id(email)
    Digest::MD5::hexdigest(email.downcase)
  end
end
