require 'test_helper'

class SummaryHelperTest < ActionView::TestCase

  test "summarizes a conversation" do
    flexmock(ConversationSummarizer).new_instances do |mock|
      mock.should_receive(:summary)
    end
    summary(Object.new)
  end

end
