require 'spec_helper'

describe ConversationsArchive do
  before do
    @account = build(:account)
    @conversations = [] 
    @messages = []

    # Create three conversations and three unique messages
    0.upto(2) do |i|
      @conversations.push create(:conversation, account: @account)
      message = create(:message, conversation: @conversations[i], content: "test #{i}")
      
      # Need to have consistent ids for VCR to work
      message.id = "c91d36fb-c406-4a06-a9b0-808c64b80e8#{i}"
      message.save!
      @messages.push message
    end

    # Create indices in Elasticsearch if not provided from VCR
    if !File.exists? Rails.root.join('spec', 'vcr', 'update_search_index.yml')
      VCR.use_cassette('update_search_index') do
        @messages.each { |message| message.__elasticsearch__.index_document }
      end
    end
  end

  describe "search" do
    it "should get conversations in elastic search order" do
      @archive = ConversationsArchive.new(@account, 'test')
      VCR.use_cassette('search_all') do
        # Test for messages/conversations in order of most recently updated
        assert_equal @archive.search_messages.to_a, @messages.sort { |a,b| b.updated_at <=> a.updated_at }
        assert_equal @archive.conversations, @conversations.sort { |a,b| b.updated_at <=> a.updated_at }
      end
    end

    it "should get specific conversations by message content" do
      @archive = ConversationsArchive.new(@account, '0')
      VCR.use_cassette('search_specific') do
        # Test for messages/conversations that match the query term
        assert_equal @archive.search_messages.to_a, [@messages.first]
        assert_equal @archive.conversations, [@conversations.first]
      end
    end
  end

end
