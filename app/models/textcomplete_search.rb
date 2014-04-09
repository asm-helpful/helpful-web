class TextcompleteSearch
  attr_accessor :account, :query

  def self.call(account, query)
    new(account, query).results
  end

  def initialize(account, query)
    self.account = account
    self.query = query
  end

  def query_regex
    %r{#{query[1..-1]}}
  end

  def query_type
    case query[0]
    when '#' then 'tag'
    when '@' then 'assignment'
    when ':' then 'canned_response'
    end
  end

  def results
    if query && query_type
      public_send("#{query_type}s")
    else
      []
    end
  end

  def tags
    [matching_tag_names.map { |tag| "##{tag}" }, query].flatten
  end

  def assignments
    matching_assignment_names.map { |assignment| "@#{assignment}" }
  end

  def canned_responses
    matching_canned_response_names.map { |canned_response| ":#{canned_response}" }
  end

  def matching_tag_names
    account.conversations.pluck(:tags).flatten.uniq.grep(query_regex)
  end

  def matching_assignment_names
    account.user_people.pluck('name').uniq.grep(query_regex)
  end

  def matching_canned_response_names
    account.canned_responses.pluck(:key).uniq.grep(query_regex)
  end
end
