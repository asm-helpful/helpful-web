require 'test_helper'

describe Api::MessagesController do
  def create_post(args = {})
    post :create,
      content:  args[:content] || 'test',
      account:  args[:account] || @account.slug,
      email:    args[:email] || 'test@example.com',
      conversation_id: args[:conversation_id] || nil,
      format: :json
  end

  def parse_body
    JSON::parse(@response.body).symbolize_keys
  end

  before do
    @account = FactoryGirl.create(:account)
  end

  describe :create do

    # Message Attributes

    it 'persists a new message' do
      assert_difference('Message.count') do
        create_post
      end
    end

    it 'returns a valid message_id' do
      create_post
      @res_body = parse_body

      assert Message.find_by_id(@res_body[:id]).valid?
    end

    it 'persists the correct content' do
      create_post
      @res_body = parse_body

      @message = Message.find_by_id(@res_body[:id])
      assert_equal @request.params[:content], @message.content
    end

    it 'persists the correct account' do
      create_post
      @res_body = parse_body

      @message = Message.find_by_id(@res_body[:id])
      assert_equal @request.params[:account], @message.account.slug
    end

    it 'persists the correct email via a person object' do
      create_post
      @res_body = parse_body

      @message = Message.find_by_id(@res_body[:id])
      assert_equal @request.params[:email], @message.person.email
    end

    # Conversation Attributes

    it 'persists a new conversation when no conversation_id is present' do
      assert_difference('Conversation.count') do
        create_post
      end
    end

    it 'does not persist a new conversation when conversation_id is passed' do
      conversation = FactoryGirl.create(:conversation, account: @account)
      assert_no_difference('Conversation.count') do
        create_post(
          conversation_id: conversation.id
        )
      end
    end

    it 'links to the correct conversation when conversation_id is passed' do
      conversation = FactoryGirl.create(:conversation, account: @account)
      create_post(
        conversation_id: conversation.id
      )
      @res_body = parse_body

      message = Message.find_by_id(@res_body[:id])
      assert Conversation.find_by_id(conversation.id).messages.include?(message)
    end

    it 'returns a valid conversation_id' do
      create_post
      @res_body = parse_body

      assert Conversation.find_by_id(@res_body[:conversation_id]).valid?
    end
  end
end
