class ConversationSerializer < BaseSerializer
  attributes :number,
             :subject,
             :archived,
             :tags

  has_one :creator

  has_many :messages
  has_many :assignment_events
  has_many :tag_events

  def path
    url_helpers.account_conversation_path(object.account, object)
  end

  # def create_message_path
  #   url_helpers.account_messages_path(object.account)
  # end
  #
  # def assignees_path
  #   url_helpers.account_conversation_assignees_path(object.account, object)
  # end
  #
  # def tags_path
  #   url_helpers.account_conversation_tags_path(object.account, object)
  # end
  #
  # def canned_responses_path
  #   url_helpers.account_canned_responses_path(object.account)
  # end
end
