require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  has_many :messages

  default_scope { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def ordered_messages
    messages.order('created_at ASC')
  end

  def participants
    ordered_messages.pluck("messages.from").uniq
  end

  def archive
    update_attribute(:archived, true)
  end

  def unarchive
    update_attribute(:archived, false)
  end

end
