# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :canned_response do
    account
    key { Faker::Lorem.word }
    message { Faker::Lorem.paragraph(3) }
  end
end
