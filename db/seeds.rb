# Current billing plans
starter_kit = BillingPlan.create slug: 'starter-kit',
                   name: "Starter Kit",
                   max_conversations: 25,
                   price: 0

BillingPlan.create slug: 'growing',
                   name: "Growing",
                   max_conversations: 50,
                   price: 29

BillingPlan.create slug: 'premium',
                   name: "Premium",
                   max_conversations: 150,
                   price: 59

BillingPlan.create slug: 'super',
                   name: "Super",
                   max_conversations: 300,
                   price: 199

account = Account.create!(name: 'Test Corp', billing_plan: starter_kit, stripe_token: 'testing')

patrick = User.create!(email: 'patrick@assemblymade.com', password: 'password')
Membership.create!(account: account, user: patrick, role: 'owner')
Person.create!(first_name: 'Patrick', email: 'patrick@assemblymade.com', user: patrick)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'The styling seems to be broken on the home page. Could you take a look?', person: patrick.person)

dave = User.create!(email: 'dave@assemblymade.com', password: 'password')
Person.create!(first_name: 'Dave', email: 'dave@assemblymade.com', user: dave, account: account)

jesse = User.create!(email: 'jesse@assemblymade.com', password: 'password')
Membership.create!(account: account, user: jesse, role: 'agent')
Person.create!(first_name: 'Jesse', email: 'jesse@assemblymade.com', user: jesse, account: account)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: "Where's the espresso machine? Wasn't it supposed to be delivered today?", person: dave.person)
conversation.messages.create(content: "Oh bummer. They sent it to 15th street for some reason. I'll give them a call and see what's up.", person: jesse.person)

chris = User.create!(email: 'chris@assemblymade.com', password: 'password')
Person.create!(first_name: 'Chris', email: 'chris@assemblymade.com', user: chris, account: account)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'Do you want to grab breakfast to chat about Helpful?', person: chris.person)
conversation.archive!
