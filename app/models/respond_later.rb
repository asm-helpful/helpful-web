class RespondLater < ActiveRecord::Base
  belongs_to :conversation

  belongs_to :user

  validates :conversation_id,
    presence: true,
    uniqueness: { scope: :user_id }

  validates :user_id,
    presence: true
end
