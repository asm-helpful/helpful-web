# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }

    factory :account_with_users do
      ignore do
        user_count 2
      end

      after(:create) do |account, evaluator|
        FactoryGirl.create_list(:membership, evaluator.user_count, account: account)
      end
    end
  end
end
