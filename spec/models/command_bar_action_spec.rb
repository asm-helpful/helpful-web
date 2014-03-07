require 'spec_helper'

describe CommandBarAction do
  it 'classifies the content' do
    expect(CommandBarAction.new(':cancel').classify_content).to eq(:canned_response)
    expect(CommandBarAction.new('@chrislloyd').classify_content).to eq(:assignment)
    expect(CommandBarAction.new('#billing').classify_content).to eq(:tag)
    expect(CommandBarAction.new('I need help please.').classify_content).to eq(:message)
  end

  context 'when the action is a message' do
    let!(:conversation) { create(:conversation) }
    let!(:person) { create(:person) }
    let!(:params) { { person: person, conversation: conversation } }

    it 'creates the correct action' do
      message = CommandBarAction.new('I need help please.', params).save
      expect(message).to be_a(Message)
    end
  end
end
