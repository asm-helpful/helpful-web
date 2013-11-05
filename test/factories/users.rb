# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password 'password'

    after(:create) do |user, evaluator|
      FactoryGirl.create_list(:membership, 1, user: user)
    end
  end
end
