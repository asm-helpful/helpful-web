require 'spec_helper'

describe CommandBarAction do
  it 'knows the type of action to process' do
    expect(CommandBarAction.new(content: ':cancel').action_type).to eq(:canned_response)
    expect(CommandBarAction.new(content: '@Chris Lloyd').action_type).to eq(:assignment)
    expect(CommandBarAction.new(content: '#billing').action_type).to eq(:tag)
    expect(CommandBarAction.new(content: 'I need help please.').action_type).to eq(:message)
  end

  context 'when the action is an assigment' do
    let!(:conversation) { create(:conversation) }
    let!(:params) { { conversation_id: conversation.id } }
    let!(:user) { create(:user) }
    let!(:person) { create(:person, name: 'Patrick Van Stee', user: user) }

    it 'assigns the conversation to a user' do
      CommandBarAction.new(params.merge(content: '@Patrick Van Stee')).save
      expect(conversation.reload.user).to eq(user)
    end
  end

  context 'when the action is an assigment' do
    let!(:conversation) { create(:conversation) }
    let!(:person) { create(:person) }
    let!(:params) { { person_id: person.id, conversation_id: conversation.id } }
    let!(:canned_response) { create(:canned_response, key: 'refund', message: 'We will refund you for last month', account: conversation.account) }

    it 'assigns the conversation to a user' do
      CommandBarAction.new(params.merge(content: ':refund')).save
      expect(conversation.messages.order('created_at DESC').last.content).to eq('We will refund you for last month')
    end
  end

  context 'when the action is a tag' do
    let!(:conversation) { create(:conversation) }
    let!(:params) { { conversation_id: conversation.id } }

    it 'adds the tag to the conversation' do
      CommandBarAction.new(params.merge(content: '#billing')).save
      expect(conversation.reload.tags).to eq(['billing'])
    end
  end

  context 'when the action is a message' do
    let!(:conversation) { create(:conversation) }
    let!(:person) { create(:person) }
    let!(:params) { { person_id: person.id, conversation_id: conversation.id } }

    it 'creates a message' do
      command_bar_action = CommandBarAction.new(params.merge(content: 'I need help please'))
      expect(command_bar_action.action).to be_a(Message)
    end
  end
end
