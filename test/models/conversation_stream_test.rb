require 'test_helper'

describe ConversationStream do

  it "fetches all items" do
    conversation = OpenStruct.new(messages: ['messages'])
    subject = ConversationStream.new(conversation)
    assert_equal ['messages'], subject.items
  end

  it "sorts items in reverse chronological order" do
    message_1 = OpenStruct.new(created_at: Time.at(1))
    message_2 = OpenStruct.new(created_at: Time.at(2))
    conversation = OpenStruct.new(messages: [message_1, message_2])
    subject = ConversationStream.new(conversation)
    assert_equal [message_2, message_1], subject.sorted_items
  end

  it "enumerates over the sorted items" do
    message_1 = OpenStruct.new(created_at: Time.at(1))
    message_2 = OpenStruct.new(created_at: Time.at(2))
    conversation = OpenStruct.new(messages: [message_1, message_2])
    subject = ConversationStream.new(conversation)

    # #to_a is defined in Enumerable, so it tests that #each is being called
    assert_equal [message_2, message_1], subject.to_a
  end

end
