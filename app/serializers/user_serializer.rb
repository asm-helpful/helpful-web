class UserSerializer < BaseSerializer
  attributes :id, :search_path

  has_one :person

  def filter(keys)
    keys.delete(:search_path) if search_path.nil?
    keys
  end

  def search_path
    scope.current_account && url_helpers.search_account_conversations_path(scope.current_account, assignee: object.id)
  end
end
