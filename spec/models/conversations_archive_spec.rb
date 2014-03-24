require 'spec_helper'

describe ConversationsArchive do
  before do
    @account = build(:account)
  end

  after do
    VCR.use_cassette('delete_index') do
      @archive.search_client.delete @message.elasticsearch_index_data
    end
  end

  it "should search" do
    conversation = create(:conversation, account: @account)
    @message = create(:message, conversation: conversation, content: 'test')

    # Need to have a consistent id to test with for VCR
    @message.id = "c91d36fb-c406-4a06-a9b0-808c64b80e8f"
    @message.save!

    @archive = ConversationsArchive.new(@account, 'test')

	  VCR.use_cassette('search') do
      @message.update_search_index
      # Give elastic search time to process the index
      sleep 1.5
      expect(@archive.conversations).to eq([conversation])
    end
  end

end
