require 'active_support/concern'

module TimestampedSerializer
  extend ActiveSupport::Concern

  included do
    attributes :created, :updated
  end

  def created
    object.created_at.iso8601
  end

  def updated
    object.updated_at.iso8601
  end
end
