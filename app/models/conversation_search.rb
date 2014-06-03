class ConversationSearch
  attr_accessor :account, :user, :params

  def self.search(account, user, params)
    new(account, user, params).results
  end

  def initialize(account, user, params)
    self.account = account
    self.user = user
    self.params = params
  end

  def results
    {
      conversations: matching_conversations,
      tags: matching_tags,
      users: matching_users
    }
  end

  def matching_conversations
    if tag_filter.present?
      conversations.where("? = ANY(tags)", tag_filter)
    elsif assignee_filter.present?
      conversations.where(user_id: assignee_filter)
    else
      matching_messages.map(&:conversation).uniq
    end
  end

  def matching_messages
    Message.search(query: { match: { content: query } }).records.select {|m| m.account.id == account.id }
  end

  def conversations
    account.conversations
  end

  def matching_tags
    if query.present?
      tags.grep(query)
    else
      tags
    end
  end

  def tags
    conversations.pluck(:tags).flatten.uniq.sort
  end

  def matching_users
    if query.present?
      users.where('name LIKE ?', "%#{query}%")
    else
      users
    end
  end

  def users
    account.users.order('name ASC')
  end

  def tag_filter
    params[:tag]
  end

  def assignee_filter
    params[:assignee]
  end

  def query
    params[:q].to_s.strip
  end
end
