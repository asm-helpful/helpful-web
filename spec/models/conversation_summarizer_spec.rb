require 'spec_helper'

describe ConversationSummarizer do
  let(:conversation) { FactoryGirl.build(:conversation) }
  let(:summarizer) { ConversationSummarizer.new(conversation) }

  it 'returns the subject if it exists' do
    conversation.subject = 'I need help please.'
    expect(summarizer.summary).to eq('I need help please.')
  end

  context 'when the subject is missing' do
    it 'returns the first message if it is short enough' do
      conversation.messages << FactoryGirl.create(:message, content: 'I need help please. But let me tell you about a bunch of other stuff too')
      expect(summarizer.summary).to eq('I need help please.')
    end

    it 'returns a truncated portion of the first message' do
      conversation.messages << FactoryGirl.create(:message, content: 'I need help please and let me tell you about a bunch of other stuff too')
      expect(summarizer.summary).to eq('I need help please and let me tell you about a bunch of other stuff too')
    end
  end
end
