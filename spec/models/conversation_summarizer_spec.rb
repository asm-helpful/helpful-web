require 'spec_helper'

describe ConversationSummarizer do

  it "clips the first messages content to Tweet size" do
    conversation = build(:conversation)
    message = build(:message, content: 'Tweet sized summary')

    conversation.messages << message

    summarizer = ConversationSummarizer.new(conversation)
    expect(summarizer.summary).to eq('Tweet sized summary')
  end

end
