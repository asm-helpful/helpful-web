class WelcomeConversation
  FROM = 'helpful@helpful.io'
  SUBJECT = 'Welcome to Helpful!'
  CONTENT = <<END
Glad you signed up. This is what your incoming support requests will look
like. Here are examples of how to use our important features.

1.  Assign it to another team member.

    ![assign.gif](https://d1015h9unskp4y.cloudfront.net/attachments/9e1eb4d9-03a0-4137-9c14-2fd927914ee2/assign.gif)

2.  Add a tag to group it with other support tickets.

    ![tag.gif](https://d1015h9unskp4y.cloudfront.net/attachments/5736caaa-83bd-47b3-bd2b-d616f0a1e51f/canned-response.gif)

3.  Use a canned response to reply with a saved message.

    ![canned-response.gif](https://d1015h9unskp4y.cloudfront.net/attachments/b39716a1-d17c-4fa5-84d1-ed12814eef64/tag.gif) 

**If you have any more questions just respond below.**

Happy supporting!
END

  def self.create(account, user)
    email = Mail::Address.new(FROM)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, subject: SUBJECT).find_conversation
    author.compose_message(conversation, CONTENT).save

    conversation
  end
end
