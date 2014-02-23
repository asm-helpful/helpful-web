require 'spec_helper'

describe ConversationStream do

  let(:item_1) { double('Item', created_at: Time.at(1)) }
  let(:item_2) { double('Item', created_at: Time.at(2)) }
  let(:item_3) { double('Item', created_at: Time.at(3)) }

  let(:conversation) do
    double('Conversation', messages: [item_1, item_3],
                           notes: [item_2]
    )
  end

  subject { described_class.new(conversation) }

  it "fetches all items" do
    expect(subject.items).to include(item_1, item_3, item_2)
  end

  it "sorts items in chronological order" do
    expect(subject.sorted_items).to eq([item_1, item_2, item_3])
  end

  it "enumerates over the sorted items" do
    expect(subject.to_a).to eq([item_1, item_2, item_3])
  end

end
