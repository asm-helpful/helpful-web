require 'spec_helper'

describe SummaryHelper do

  let(:conversation) { double('Conversation', subject: 'YOLO') }

  it "summarizes a conversation" do
    expect(helper.summary(conversation)).to eq('YOLO')
  end

end
