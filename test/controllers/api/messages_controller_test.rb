require 'test_helper'

describe(Api::MessagesController, :create) do

  def create_post(account, args = {})
    post :create, :content      => args[:content] || 'test',
                  :account      => args[:account] || account.slug,
                  :email        => args[:email] || 'test@example.com',
                  :conversation => args[:conversation] || nil,
                  :format       => :json
  end

  def parse_json_response(response)
    JSON.parse(response.body).symbolize_keys
  end

  def find_message_from_response(response)
    Message.find(parse_json_response(response)[:id])
  end


  before do
    @controller = Api::MessagesController.new
    @account = create(:account)
  end


  # Messages

  it 'persists a new message' do
    create_post(@account)
    message = find_message_from_response(@response)
    assert_not_nil message
  end

  it 'persists the correct content' do
    create_post(@account, content: 'I need halp!')
    message = find_message_from_response(@response)
    assert_equal 'I need halp!', message.content
  end

  it 'persists the correct account' do
    create_post(@account)
    message = find_message_from_response(@response)
    assert_equal @account, message.account
  end

  it 'persists the correct email via a person object' do
    create_post(@account, email: 'chris@example.com')
    message = find_message_from_response(@response)
    assert_equal 'chris@example.com', message.person.email
  end


  # Conversations

  it 'persists a new conversation when no conversation_id is present' do
    assert_difference(-> { Conversation.count }, 1) do
      create_post(@account)
    end
  end

  it 'does not persist a new conversation when conversation_id is passed' do
    conversation = create(:conversation, account: @account)
    assert_no_difference(-> { Conversation.count }) do
      create_post(@account, conversation: conversation.number)
    end
  end

  it 'links to the correct conversation when conversation_id is passed' do
    conversation = create(:conversation, account: @account)
    create_post(@account, conversation: conversation.number)
    message = find_message_from_response(@response)
    assert_equal conversation, message.conversation
  end

end
