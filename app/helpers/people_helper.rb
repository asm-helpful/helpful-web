module PeopleHelper

  # Public: View helper to provide an avatar div & img for a given user.
  #
  # person - a Person or User object. Must have an email attribute.
  #
  # options - an optional hash of options to be applied to the div, accepts
  #           the same options as content_tag. Defaults to the avatar class.
  #
  # Returns a img tag wraped in a div with the class of avatar.
  def avatar(person, options={ class: "avatar" })
    src = gravatar(person)
    content_tag(:div, options) do
      image_tag src
    end
  end

  # Internal: Helper to provide the gravatar_url for a given person.
  #
  # person - a Person or User object. Must have an email attribute.
  #
  # Returns a url to the PNG of the user's gravatar.
  def gravatar(person)
    gravatar_id = Digest::MD5::hexdigest(person.email).downcase
    base_url = "gravatar.com/avatar/#{gravatar_id}.png?s=60&d=retro"
    (request.ssl? ? "https://" : "http://") + base_url
  end
end
