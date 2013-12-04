# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    conversation
    person
    content { Faker::Lorem.paragraph(3) }
  end
end
