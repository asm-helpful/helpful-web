module SummaryHelper

  def summary(conversation)
    ConversationSummarizer.new(conversation).summary
  end

end
