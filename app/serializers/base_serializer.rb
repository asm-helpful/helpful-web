class BaseSerializer < ActiveModel::Serializer
  include TimestampedSerializer

  attributes :id, :type

  def type
    object.class.name.downcase
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def current_user
    scope.current_user
  end

  def current_account
    scope.current_account
  end
end
