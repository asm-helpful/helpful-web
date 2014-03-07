require 'spec_helper'

describe CommandBarAction do
  it 'classifies the content' do
    expect(CommandBarAction.new(content: ':cancel').classify_content).to eq(:canned_response)
    expect(CommandBarAction.new(content: '@Chris Lloyd').classify_content).to eq(:assignment)
    expect(CommandBarAction.new(content: '#billing').classify_content).to eq(:tag)
    expect(CommandBarAction.new(content: 'I need help please.').classify_content).to eq(:message)
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

  context 'when the action is an assigmnet' do
    let!(:conversation) { create(:conversation) }
    let!(:params) { { conversation_id: conversation.id } }
    let!(:user) { create(:user) }
    let!(:person) { create(:person, name: 'Patrick Van Stee', user: user) }

    it 'assigns the conversation to a user' do
      CommandBarAction.new(params.merge(content: '@Patrick Van Stee')).save
      expect(conversation.reload.user).to eq(user)
    end
  end
end
