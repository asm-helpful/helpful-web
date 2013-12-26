# Represents a conversation in its entirety. It may be made up of multiple
# different sets of objects. It fetches them and then merges them together
# in a reverse chronological sort order (first item newest).
#
# This is a horribly innefficient class because it makes multiple calls out to
# the database. It exists so that the underlying data models don't have to use
# STI but can be still displayed in the same view.
#
# Heavy caching reccomended for any dependant views of this class.
class ConversationStream
  include Enumerable

  attr_reader :conversation

  def initialize(conversation)
    @conversation = conversation
  end

  def each
    sorted_items.each {|item| yield(item) }
  end

  # protected

  def items
    conversation.messages.to_a
  end

  def sorted_items
    items.sort_by {|i| i.created_at }.reverse
  end

end
