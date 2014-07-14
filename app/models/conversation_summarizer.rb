class ConversationSummarizer
  include ActionView::Helpers::TextHelper

  LENGTH = 140

  attr_accessor :conversation

  def self.summary(conversation)
    new(conversation).summary
  end

  def initialize(conversation)
    self.conversation = conversation
  end

  def summary
    if subject.present?
      subject
    elsif first_sentence.size <= LENGTH
      first_sentence
    else
      truncated_message
    end
  end

  def subject
    conversation.subject
  end

  def first_sentence
    sentence = first_message && first_message.partition(/\.|\?|\!|\s\-\s/)[0..1].join
    sentence.to_s.strip.chomp('-').strip
  end

  def truncated_message
    first_message && truncate(first_message, length: LENGTH, separator: ' ').html_safe
  end

  def first_message
    conversation.first_message && conversation.first_message.content
  end
end
