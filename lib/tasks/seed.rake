namespace :db do
  task :seed => :environment do
    # An initial account
    user_params = {email: 'example@example.com', password: 'password', password_confirmation: 'password'}
    account_params = {name: 'Example'}
    person_params = {name: "Example Admin"}

    @new_account_user = User.new user_params
    @account = Account.new account_params
    @person = Person.new person_params

    @person.email = @new_account_user.email
    @person.account = @account

    @account.new_account_user = @new_account_user
    @new_account_user.person = @person

    @account.save!

    # Rough billing outline
    # These are some example IDs that correspond to the Chargify dev subdomain 'helpful-dev'
    BillingPlan.create slug: 'bronze', name: "Bronze", chargify_product_id: '3362368', max_conversations: 25, price: 39
    BillingPlan.create slug: 'silver', name: "Silver", chargify_product_id: '3362369', max_conversations: 250, price: 99
    BillingPlan.create slug: 'gold',   name: "Gold",   chargify_product_id: '3362370', max_conversations: 1000, price: 199
  end
end

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
