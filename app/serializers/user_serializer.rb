class UserSerializer < BaseSerializer
  attributes :id

  has_one :person
end
