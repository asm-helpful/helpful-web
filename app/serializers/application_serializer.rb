class ApplicationSerializer < ActiveModel::Serializer

  attributes :id,
             :type,
             :created,
             :updated,
             :url

  def type
    object.class.name.downcase
  end

  def created
    object.created_at.iso8601
  end

  def updated
    object.updated_at.iso8601
  end

  def url
    nil
  end

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end
  #
  # def current_user
  #   scope.current_user
  # end
  #
  # def current_account
  #   scope.current_account
  # end
end
