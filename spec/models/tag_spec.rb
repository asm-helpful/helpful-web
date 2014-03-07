require 'spec_helper'

describe Tag do
  let!(:conversation) { create(:conversation) }

  it 'adds the tag to the conversation' do
    Tag.new(content: '#billing', conversation_id: conversation.id).save
    expect(conversation.reload.tags).to eq(['billing'])
  end

  it 'only adds the tag once' do
    Tag.new(content: '#billing', conversation_id: conversation.id).save
    Tag.new(content: '#legal', conversation_id: conversation.id).save
    Tag.new(content: '#billing', conversation_id: conversation.id).save
    expect(conversation.reload.tags).to eq(['billing', 'legal'])
  end
end
