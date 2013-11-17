# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :account do
    name { Faker::Company.name }
  end

  factory :beta_invite do
    email { Faker::Internet.email }
  end

  factory :email, class: Messages::Email do
    conversation
    person
  end

  factory :membership do
    account
    user
    role 'owner'
  end

  factory :message do
    conversation
    person
  end

  factory :person do
    name    { Faker::Name.name }
    email   { Faker::Internet.email }
    twitter { Faker::Internet.user_name }
  end

  factory :user do
    email    { Faker::Internet.email }
    password 'password'

    after(:create) do |user, evaluator|
      FactoryGirl.create_list(:membership, 1, user: user)
    end
  end

end
