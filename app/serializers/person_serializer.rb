class PersonSerializer < ActiveModel::Serializer

  attributes :id
  attributes :name, :email, :twitter, :created, :updated

  def created
    object.created_at.iso8601
  end

  def updated
    object.updated_at.iso8601
  end

end
