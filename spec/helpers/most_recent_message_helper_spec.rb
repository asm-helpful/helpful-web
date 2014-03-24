require 'spec_helper'

describe MostRecentMessageHelper do
  it "returns a css class that describes the age of the message" do
    { 'recent' => 5.minutes.ago, 'normal' => 1.day.ago, 'stale' => 4.days.ago }.each do |description, time|
      message = double("message", updated_at: time)
      conversation = double("conversation", most_recent_message: message)

      assert_equal most_recent_message_class(conversation), description
    end
  end
end
