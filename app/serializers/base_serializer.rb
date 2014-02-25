class BaseSerializer < ActiveModel::Serializer
  include TimestampedSerializer

  attributes :id, :type

  def type
    object.class.name.downcase
  end

end
