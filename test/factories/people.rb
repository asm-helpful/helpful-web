# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    name "Person Name"
    email Faker::Internet.email
    twitter "twitterhandle"
  end
end
