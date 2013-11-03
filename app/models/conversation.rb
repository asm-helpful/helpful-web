require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  has_many :messages

  def ordered_messages
    messages.order('created_at ASC')
  end

  def participants
    ordered_messages.pluck("messages.from").uniq
  end
end
