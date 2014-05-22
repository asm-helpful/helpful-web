class TextcompleteSearch
  attr_accessor :account, :query, :query_type

  def self.call(account, query, query_type)
    new(account, query, query_type).results
  end

  def initialize(account, query, query_type)
    self.account = account
    self.query = query
    self.query_type = query_type
  end

  def query_regex
    Regexp.new(Regexp.escape(query))
  end

  def results
    if query.present? && query_type
      public_send(query_type)
    else
      []
    end
  end

  def tags
    (matching_tags + [query]).uniq.map { |tag| { type: 'tag', value: tag } }
  end

  def assignments
    matching_assignments.map { |name, user_id| { type: 'assignment', user_id: user_id, value: name } }
  end

  def canned_responses
    matching_canned_responses.map { |key, id| { type: 'canned_response', id: id, value: key } }
  end

  def matching_tags
    account.conversations.pluck(:tags).flatten.uniq.grep(query_regex)
  end

  def matching_assignments
    account.user_people.where('name ILIKE ?', "#{query}%").pluck(:name, :user_id)
  end

  def matching_canned_responses
    account.canned_responses.where('key ILIKE ?', "#{query}%").pluck(:key, :id)
  end
end
