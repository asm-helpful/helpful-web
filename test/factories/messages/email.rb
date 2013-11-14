# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email, class: Messages::Email do
    from { Faker::Internet.email }
    conversation 
  end
end
