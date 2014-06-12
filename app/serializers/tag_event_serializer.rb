class TagEventSerializer < BaseSerializer
  include ActionView::Helpers::DateHelper
  include AvatarHelper
  include Rails.application.routes.url_helpers

  attributes :tag, :initials, :avatar_url, :name, :updated_at_in_words, :user_url, :tag_url

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

  def user_url
    search_account_conversations_path(object.conversation.account, assignee: object.user.id)
  end

  def tag_url
    search_account_conversations_path(object.conversation.account, tag: object.tag)
  end
end
