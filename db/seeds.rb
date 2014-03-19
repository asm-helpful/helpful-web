account = Account.create!(name: 'Test Corp')

patrick = User.create!(email: 'patrick@assemblymade.com', password: 'password')
Membership.create!(account: account, user: patrick, role: 'owner')
Person.create!(name: 'Patrick', email: 'patrick@assemblymade.com', user: patrick)
patrick.confirm!

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'The styling seems to be broken on the home page. Could you take a look?', person: patrick.person)

dave = User.create!(email: 'dave@assemblymade.com', password: 'password')
Person.create!(name: 'Dave', email: 'dave@assemblymade.com', user: dave, account: account)
dave.confirm!

jesse = User.create!(email: 'jesse@assemblymade.com', password: 'password')
Membership.create!(account: account, user: jesse, role: 'agent')
Person.create!(name: 'Jesse', email: 'jesse@assemblymade.com', user: jesse, account: account)
jesse.confirm!

conversation = Conversation.create!(account: account)
conversation.messages.create(content: "Where's the espresso machine? Wasn't it supposed to be delivered today?", person: dave.person)
conversation.messages.create(content: "Oh bummer. They sent it to 15th street for some reason. I'll give them a call and see what's up.", person: jesse.person)

chris = User.create!(email: 'chris@assemblymade.com', password: 'password')
Person.create!(name: 'Chris', email: 'chris@assemblymade.com', user: chris, account: account)
chris.confirm!

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'Do you want to grab breakfast to chat about Helpful?', person: chris.person)
conversation.archive!

# Rough billing outline
# These are some example IDs that correspond to the Chargify dev subdomain 'helpful-dev'
BillingPlan.create slug: 'bronze',
                   name: "Bronze",
                   chargify_product_id: '3362368',
                   max_conversations: 25,
                   price: 39

BillingPlan.create slug: 'silver',
                   name: "Silver",
                   chargify_product_id: '3362369',
                   max_conversations: 250,
                   price: 99

BillingPlan.create slug: 'gold',
                   name: "Gold",
                   chargify_product_id: '3362370',
                   max_conversations: 1000,
                   price: 199
