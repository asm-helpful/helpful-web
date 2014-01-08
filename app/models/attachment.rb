class Attachment < ActiveRecord::Base

  mount_uploader :file, AttachmentUploader

  belongs_to :message

  validates :message, presence: true
  validates :file, presence: true

end
