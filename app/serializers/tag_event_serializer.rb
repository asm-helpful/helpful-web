class TagEventSerializer < BaseSerializer
  include Rails.application.routes.url_helpers

  attributes :tag, :search_path

  has_one :user,
    serializer: UserSerializer

  def search_path
    search_account_conversations_path(object.conversation.account, tag: object.tag)
  end
end
