require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  has_many :messages

  before_save :set_conversation_number, only: :create

  # Private: Helper function to set the conversation number, acts as an auto
  # incrementing value within a given account.
  #
  # Returns nothing.
  def set_conversation_number
    self.number = Conversation.where(account: self.account).count + 1
  end
end
