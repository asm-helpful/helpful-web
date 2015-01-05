require 'spec_helper'

describe(IncomingMessagesController, :create) do

  def create_post(account, args = {})
    post :create, :content      => args[:content] || 'test',
         :account      => args[:account] || account.slug,
         :email        => args[:email] || 'test@example.com',
         :conversation => args[:conversation] || nil,
         :attachment   => args[:attachment] || nil,
         :format       => :json
  end

  def parse_json_response(response)
    JSON.parse(response.body)
  end

  def find_message_from_response(response)
    Message.find(parse_json_response(response)['message']['id'])
  end

  before do
    #@controller = MessagesController.new
    @account = create(:account)
  end


  # Messages

  it 'persists a new message' do
    create_post(@account)
    message = find_message_from_response(@response)
    expect(message).to_not be_nil
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

  it 'persists the correct email via a person object' do
    create_post(@account, email: 'Chris <chris@example.com>')
    message = find_message_from_response(@response)
    assert_equal 'chris@example.com', message.person.email
  end

  it 'persists the correct name from the email via a person object' do
    create_post(@account, email: 'Chris <chris@example.com>')
    message = find_message_from_response(@response)
    assert_equal 'Chris', message.person.name
  end

  # Conversations

  it 'persists a new conversation when no conversation_id is present' do
    expect { create_post(@account) }.to change { Conversation.count }.by(1)
  end

  it 'does not persist a new conversation when conversation_id is passed' do
    conversation = create(:conversation, account: @account)
    expect { create_post(@account, conversation: conversation.number) }.to_not change { Conversation.count }
  end

  it 'links to the correct conversation when conversation_id is passed' do
    conversation = create(:conversation, account: @account)
    create_post(@account, conversation: conversation.number)
    message = find_message_from_response(@response)
    assert_equal conversation, message.conversation
  end

  it 'add attachments to messages' do
    conversation = create(:conversation, account: @account)
    create_post(@account, conversation: conversation.number, attachment: File.new(File.join(Rails.root, "app", "assets", "images", "logo.png")))
    message = find_message_from_response(@response)
    assert_equal message.attachments.count, 1
  end
end
