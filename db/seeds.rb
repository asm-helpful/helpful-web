# --- Account ---
supportly = Account.create(name: 'Supportly')

# --- User ---
user = User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')
Membership.create!(account: supportly, user: user, role: 'owner')

# --- Conversations ---
messages = [
  [ ['Chris', "Hey I'm having trouble logging in."],
    ['Dave',  "I'm sorry to hear that, Chris."]
  ],
  [ ['John',  "I can't connect to my Minecraft server"]
  ],
  [ ['Matt',  "I need a refund"],
    ['Chris', "I'll make sure accounting sees this."]
  ],
  [ ['Peldi', "Do you guys support port 123?"],
    ['Chris', "I'll make sure accounting sees this."]
  ]
]

Message.record_timestamps = false # so we can backdate seeds

messages.each_with_index do |message_list, i|
  c = supportly.conversations.create

  message_list.each do |message|
    past = (i*2).minutes.ago

    c.messages.create from: message[0],
                   content: message[1],
                updated_at: past,
                created_at: past

  end
end
