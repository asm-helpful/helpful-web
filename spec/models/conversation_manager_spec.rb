require 'spec_helper'

describe ConversationManager do
  let(:conversation) { double('Conversation') }
  let(:user) { double('User') }
  let(:conversation_manager) { ConversationManager.new(conversation, user) }
  let(:params) { double('params') }

  it 'takes an action if needed' do
    expect(conversation_manager).to receive(:create_assignment_event) { nil }
    expect(conversation_manager).to receive(:lookup_action) { :archive! }

    expect(conversation).to receive(:archive!)

    conversation_manager.manage(params)
  end

  it 'just updates the conversation if an action is not matched' do
    expect(conversation_manager).to receive(:create_assignment_event) { nil }
    expect(conversation_manager).to receive(:lookup_action) { nil }

    expect(conversation).to receive(:update).with(params)

    conversation_manager.manage(params)
  end

  it 'takes the correct action' do
    expect(conversation_manager.lookup_action(archive: true)).to eq(:archive!)
    expect(conversation_manager.lookup_action(unarchive: true)).to eq(:unarchive!)
  end
end
