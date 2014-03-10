class ConversationMailbox < ActiveRecord::Base
  self.primary_key = :id
  
  belongs_to :conversation
  belongs_to :account

  # Public: Mail address for the conversation mailbox
  #
  # Returns the Mail::Address customers should send email replies to
  def address
    Mail::Address.new("#{self.id}@#{Helpful.incoming_email_domain}")
  end

  # Public: Hash representation the conversation mailbox
  #
  # Returns a hash
  def to_h
    {
      account_slug: self.account.slug,
      conversation_number: self.conversation.number
    }
  end
end
