require 'spec_helper'

describe MostRecentMessageHelper do
  it "returns a css class that describes the age of the message" do
    { 'recent' => 5.minutes.ago, 'normal' => 1.day.ago, 'stale' => 4.days.ago }.each do |description, time|
      message = double("message", updated_at: time)
      conversation = double("conversation", most_recent_message: message)

      expect(most_recent_message_class(conversation)).to eq(description)
    end
  end

  it "defaults to using the last updated timestamp of the conversation if a message is not found" do
    conversation = double("conversation", most_recent_message: nil, updated_at: 5.days.ago)

    expect(most_recent_message_class(conversation)).to eq('stale')
  end
end
