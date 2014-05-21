# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :billing_plan do
    slug 'starter-kit'
    name 'Starter Kit'
    max_conversations 5
    price 500
  end
end
