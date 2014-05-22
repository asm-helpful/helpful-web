class ExampleConversation
  SUBJECT = 'Halp, everything is broken!'
  CONTENT = 'I just visited your site for the first time and the color of red you chose for your logo is a little bit too bright. Please fix it immediately.'

  def self.create(account, user)
    email = Mail::Address.new(user.person.email)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, subject: SUBJECT).find_conversation
    author.compose_message(conversation, CONTENT).save

    conversation
  end
end
