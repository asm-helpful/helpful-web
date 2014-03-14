class CannedResponse < ActiveRecord::Base
  belongs_to :account

  validates :key,
    presence: true,
    uniqueness: { scope: :account_id }

  validates :message,
    presence: true

  validates :account_id,
    presence: true
end
