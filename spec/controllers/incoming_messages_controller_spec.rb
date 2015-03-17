require 'spec_helper'

describe(IncomingMessagesController, :create) do

  def create_post(account, args = {})
    post :create, :content      => args[:content] || 'test',
         :account      => args[:account] || account.slug,
         :email        => args[:email] || 'test@example.com',
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


end
