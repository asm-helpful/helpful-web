class WelcomeConversation
  FROM = 'helpful@helpful.io'
  SUBJECT = 'Welcome to Helpful!'
  CONTENT = <<END
Glad you signed up. This is what your incoming support requests will look
like. Here are examples of how to use our important features.

1.  Assign it to another team member.

    ![assign.gif](https://d1015h9unskp4y.cloudfront.net/attachments/6cb6a5b4-cb6e-4741-94e5-c2aff8fc2e11/assign.gif)

2.  Add a tag to group it with other support tickets.

    ![tag.gif](https://d1015h9unskp4y.cloudfront.net/attachments/3cfb2f79-8117-4093-a2bd-e830665d7f93/tag.gif)

3.  Use a canned response to reply with a saved message.

    ![canned-response.gif](https://d1015h9unskp4y.cloudfront.net/attachments/4fb59ca4-11c7-45b9-bd74-74d1aa03a482/canned-response.gif) 

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
