class AssignmentEventSerializer < BaseSerializer
  include ActionView::Helpers::DateHelper
  include AvatarHelper
  include Rails.application.routes.url_helpers

  attributes :initials, :avatar_url, :name, :user_url, :assignee_initials, :assignee_avatar_url, :assignee_name, :assignee_url, :updated_at_in_words

  def initials
    object.user.person.initials
  end

  def avatar_url
    gravatar_url(object.user.person.email, 30)
  end

  def name
    object.user.person.name
  end

  def user_url
    search_account_conversations_path(object.conversation.account, assignee: object.user.id)
  end

  def assignee_initials
    object.assignee.person.initials
  end

  def assignee_avatar_url
    gravatar_url(object.assignee.person.email, 30)
  end

  def assignee_name
    object.assignee.person.name
  end

  def assignee_url
    search_account_conversations_path(object.conversation.account, assignee: object.assignee.id)
  end

  def updated_at_in_words
    time_ago_in_words(object.updated_at)
  end
end
