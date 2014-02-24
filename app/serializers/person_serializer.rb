class PersonSerializer < ActiveModel::Serializer
  include TimestampedSerializer

  attributes :id
  attributes :name, :email

end
