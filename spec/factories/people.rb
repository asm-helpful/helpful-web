# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    name    { Faker::Name.name }
    email   { Faker::Internet.email }
    twitter { Faker::Internet.user_name + Random.rand(1950..2000).to_s }
    username { Faker::Internet.user_name  }
  end
end
