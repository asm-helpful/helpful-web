class WelcomeConversation
  SUBJECT = 'Welcome to Helpful! Test drive your new Inbox.'

  def self.create(account, user)
    email = Mail::Address.new('patrick@mail.helpful.io')
    email.display_name = 'Patrick Van Stee'

    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, subject: SUBJECT).find_conversation
    author.compose_message(conversation, content(account)).save

    conversation
  end

  def self.content(account)
    <<END
Glad you signed up. You just clicked on your first support request. Cool, huh?
And this entire page is your Inbox, where all of the messages from your
customers will show up. You can think of it just like a shared email inbox.

Oh, and here's your new Helpful email address:
<a href="mailto:#{account.email}">#{account.email}</a>. Go ahead and try it out by
sending an email to that address. It will show up right above this
conversation. You can go ahead and start using this as your support email or
start <a href="/#{account.slug}/help#email-forwarding">forwarding emails from another email address</a>.

If you have any trouble or want to ask a question, just send a reply below.
Your message will be sent straight to me. Animated cat gifs are also
appreciated.

Happy supporting!
END
  end
end
