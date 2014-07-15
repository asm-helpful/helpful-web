class ConversationMailbox
  attr_accessor :account, :user, :params

  def self.find(account, user, params)
    new(account, user, params).find
  end

  def initialize(account, user, params)
    self.account = account
    self.user = user
    self.params = params
  end

  def find
    if search?
      search
    elsif archive?
      archive
    elsif inbox?
      inbox
    else
      account_conversations
    end
  end

  def inbox
    account_conversations.unresolved.order('updated_at DESC')
  end

  def inbox?
    params[:archived] == 'false'
  end

  def archive
    account_conversations.archived.order('created_at DESC')
  end

  def archive?
    params[:archived] == 'true'
  end

  def account_conversations
    account.conversations.with_messages.
      includes(messages: [:person, :attachments]).
      includes(first_message: :person).
      includes(:most_recent_message).
      includes(assignment_events: [{ user: :person }, { assignee: :person }]).
      includes(tag_events: { user: :person }).
      with_message_count
  end

  def search
    ConversationSearch.new(account, user, { q: query, tag: tag, assignee: assignee }).matching_conversations
  end

  def search?
    [query, tag, assignee].any?(&:present?)
  end

  def query
    params[:q].to_s.strip
  end

  def tag
    params[:tag].to_s.strip
  end

  def assignee
    params[:assignee].to_s.strip
  end
end
