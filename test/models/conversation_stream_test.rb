require 'test_helper'

describe ConversationStream do

  it "fetches all items" do
    conversation = OpenStruct.new(messages: ['message'], notes: ['note'])
    subject = ConversationStream.new(conversation)
    assert_equal ['message', 'note'], subject.items
  end

  it "sorts items in reverse chronological order" do
    item_1 = OpenStruct.new(created_at: Time.at(1))
    item_2 = OpenStruct.new(created_at: Time.at(2))
    item_3 = OpenStruct.new(created_at: Time.at(3))
    conversation = OpenStruct.new(
      messages: [item_1, item_3],
      notes: [item_2]
    )
    subject = ConversationStream.new(conversation)
    assert_equal [item_3, item_2, item_1], subject.sorted_items
  end

  it "enumerates over the sorted items" do
    item_1 = OpenStruct.new(created_at: Time.at(1))
    item_2 = OpenStruct.new(created_at: Time.at(2))
    item_3 = OpenStruct.new(created_at: Time.at(3))
    conversation = OpenStruct.new(
      messages: [item_1, item_3],
      notes: [item_2]
    )
    subject = ConversationStream.new(conversation)
    # #to_a is defined in Enumerable, so it tests that #each is being called
    assert_equal [item_3, item_2, item_1], subject.to_a
  end

end
