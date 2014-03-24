require 'spec_helper'

describe MostRecentMessageHelper do
  it "returns a css class that describes the age of the message" do
    { 'recent' => 5.minutes.ago, 'normal' => 1.day.ago, 'stale' => 4.days.ago }.each do |description, time|
      conversation = double("conversation", last_activity_at: time)

      expect(most_recent_message_class(conversation)).to eq(description)
    end
  end
end
