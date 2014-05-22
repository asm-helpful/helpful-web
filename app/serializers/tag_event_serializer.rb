class TagEventSerializer < BaseSerializer
  include ActionView::Helpers::DateHelper
  include AvatarHelper

  attributes :tag, :initials, :avatar_url, :name, :updated_at_in_words

  def initials
    object.user.person.initials
  end

  def avatar_url
    gravatar_url(object.user.person.email, 30)
  end

  def name
    object.user.person.name
  end

  def updated_at_in_words
    time_ago_in_words(object.updated_at)
  end
end
