class PersonSerializer < ActiveModel::HalSerializer
  include TimestampedSerializer

  attributes :id
  attributes :name, :email, :twitter

  link :self do |person|
    { href: "/people/#{person.id}" }
  end
end
