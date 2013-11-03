# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:random_string) do |n|
    ("A".."z").to_a.shuffle.take(5).join
  end

  factory :account do
    name { generate(:random_string) }
  end
end
