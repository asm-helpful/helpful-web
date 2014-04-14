class TextcompleteSearch
  attr_accessor :account, :query

  def self.call(account, query)
    new(account, query).results
  end

  def initialize(account, query)
    self.account = account
    self.query = query
  end

  def cleaned_query
    query[1..-1]
  end

  def query_regex
    Regexp.new(Regexp.escape(cleaned_query))
  end

  def query_type
    case query[0]
    when '#' then 'tag'
    when '@' then 'assignment'
    when ':' then 'canned_response'
    end
  end

  def results
    if cleaned_query.present? && query_type
      public_send("#{query_type}s")
    else
      []
    end
  end

  def tags
    (matching_tags + [cleaned_query]).uniq.map { |tag| { type: 'tag', value: "##{tag}" } }
  end

  def assignments
    matching_assignments.map { |name, user_id| { type: 'assignment', user_id: user_id, value: "@#{name}" } }
  end

  def canned_responses
    matching_canned_responses.map { |key, id| { type: 'canned_response', id: id, value: ":#{canned_response}" } }
  end

  def matching_tags
    account.conversations.pluck(:tags).flatten.uniq.grep(query_regex)
  end

  def matching_assignments
    account.user_people.where('name ILIKE ?', "#{cleaned_query}%").pluck(:name, :user_id)
  end

  def matching_canned_responses
    account.canned_responses.where('key ILIKE ?', "#{cleaned_query}%").pluck(:key, :id)
  end
end
