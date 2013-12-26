class Note < ActiveRecord::Base

  belongs_to :user
  belongs_to :conversation

  validates :content, presence: true
  validates :user, presence: true
  validates :conversation, presence: true

end
