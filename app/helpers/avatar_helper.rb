module AvatarHelper
  def avatar_default(person)
    avatar(person, 20)
  end

  def avatar(person, size)
    image_tag(avatar_path(person, size * 2), class: 'avatar', width: size, height: size)
  end

  def avatar_path(person, size)
    person.avatar.try(:thumb).present? ? person.avatar.thumb : gravatar_url(person.email, size)
  end

  def gravatar_url(email, size)
    id = gravatar_id(email)
    "https://secure.gravatar.com/avatar/#{id}.png?s=#{size}&d=404"
  end

  def gravatar_id(email)
    Digest::MD5::hexdigest(email.downcase)
  end
end
