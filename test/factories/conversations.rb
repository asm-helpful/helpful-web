# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    account

    factory :archived_conversation do
      status :archived
    end

    factory :conversation_with_messages do
      ignore do
        messages_count 5
      end

      after(:create) do |conversation, evaluator|
        FactoryGirl.create_list(:message, evaluator.messages_count,
          conversation: conversation
        )
      end
    end
  end
end
