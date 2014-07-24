class WidgetConversation
  FROM = 'wesleylancel@gmail.com'
  SUBJECT = 'Install our handy widget on your website.'

  def self.create(account, user)
    email = Mail::Address.new(FROM)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, subject: SUBJECT).find_conversation
    author.compose_message(conversation, content(account)).save

    conversation
  end

  def self.content(account)
  <<END
Want to give your users a quicker way to send you feedback? Check out or embeddable widget.

All you have to do is include our script on your site and wire up a new button.
New messages will show up in your inbox just like a new email. To get started,
head on over to our <a href="/#{account.slug}/help#widget">help page</a> and try it out for yourself.

Here's a quick gif of how it looks on Assembly's website:

<img src="https://d1015h9unskp4y.cloudfront.net/attachments/e1969d33-ae54-4a87-8c3a-54d7a76c08fc/widget-on-assembly.gif">

If you're having any trouble, you have a direct line to the developer who
created it, me, Wesley. Just ask a question below and I'd be happy to help out.

Cheers!
END
  end
end
