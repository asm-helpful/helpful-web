# Accounts

account = Account.create!(name: 'Test Corp')

patrick = User.create!(email: 'patrick@example.com', password: 'password')
Membership.create!(account: account, user: patrick, role: 'owner')
Person.create!(name: 'Patrick', email: 'patrick@example.com', user: patrick)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'The styling seems to be broken on the home page. Could you take a look?', person: patrick.person)

dave = User.create!(email: 'dave@example.com', password: 'password')
Person.create!(name: 'Dave', email: 'dave@example.com', user: dave, account: account)

jesse = User.create!(email: 'jesse@example.com', password: 'password')
Membership.create!(account: account, user: jesse, role: 'agent')
Person.create!(name: 'Jesse', email: 'jesse@example.com', user: jesse, account: account)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: "Where's the espresso machine? Wasn't it supposed to be delivered today?", person: dave.person)
conversation.messages.create(content: "Oh bummer. They sent it to 15th street for some reason. I'll give them a call and see what's up.", person: jesse.person)

chris = User.create!(email: 'chris@example.com', password: 'password')
Person.create!(name: 'Chris', email: 'chris@example.com', user: chris, account: account)

conversation = Conversation.create!(account: account)
conversation.messages.create(content: 'Do you want to grab breakfast to chat about Helpful?', person: chris.person)
conversation.archive!
