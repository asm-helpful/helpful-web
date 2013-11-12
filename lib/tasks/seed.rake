namespace :seed do
  task :message => :environment do
    account = Account.first!
    
    Message.record_timestamps = false_to_backdate_seeds = false
    past = rand(1000).minutes.ago
    from = ENV['from'] || Faker::Internet.email
    
    conversation = account.conversations.create
    conversation.messages.create(
      person:  Person.find_or_create_by!(:email => from),
      content: Faker::Lorem.paragraph,
      updated_at: past,
      created_at: past
    )
  end
end