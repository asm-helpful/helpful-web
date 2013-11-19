FactoryGirl.define do
  factory :webhook do
    account
    event 'test.test'
    data { {'foo' => 'bar'} }
  end
end
