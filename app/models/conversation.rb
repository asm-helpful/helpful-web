require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  has_many :messages

  scope :unarchived, -> { where.not(status: "archived") }
  scope :archived, -> { where(status: "archived") }

  def ordered_messages
    messages.order('created_at ASC')
  end

  def participants
    ordered_messages.pluck("messages.from").uniq
  end

  def archived?
    !status.blank? && status == "archived"
  end

  def archive
    update_attribute(:status, "archived")
  end

  def unarchive
    if status == "archived"
      update_attribute(:status, nil)
    end
  end

end
