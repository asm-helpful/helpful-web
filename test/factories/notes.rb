# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    content { Faker::Lorem.paragraph(3) }
    user
    conversation
  end
end
