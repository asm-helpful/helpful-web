require 'spec_helper'

describe CannedResponseMessage do
  let!(:conversation) { create(:conversation) }
  let!(:person) { create(:person, account: conversation.account) }
  let!(:canned_response) { create(:canned_response, key: 'refund', message: 'We will refund you for last month', account: conversation.account) }

  it 'creates a message with the canned response matching the key' do
    CannedResponseMessage.new(content: ':refund', conversation_id: conversation.id, person: person).save

    response = conversation.messages.order('created_at DESC').last

    expect(response.content).to eq('We will refund you for last month')
    expect(response.person).to eq(person)
  end
end
