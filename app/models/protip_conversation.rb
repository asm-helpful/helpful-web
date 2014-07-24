class ProtipConversation
  FROM = 'chris@assembly.com'
  SUBJECT = 'Answer support requests like a boss with some Helpful protips.'
  def self.create(account, user)
    email = Mail::Address.new(FROM)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, subject: SUBJECT).find_conversation
    author.compose_message(conversation, content(account)).save

    conversation
  end

  def self.content(account)
    <<END
Right now you're probably still just settling in, but we want to make sure you
get the most out of Helpful. Here are a few tips that will come in handy as you
become a pro user.

**Invite your whole team**

You can have as many members as you want, our plans are all related to how many
support requests you handle each month. So add your CEO and even that new
internet. If they can help with support, <a href="/#{account.slug}/edit#team">sign 'em up</a>.

**Having support request Déjà vu? Use canned responses**

Retyping common responses is a drag. That's why we built canned responses; so
you can quickly send a saved response to frequent questions. Also you can
refine these replies overtime to explain solutions the best way possible and
then stay consistent across your entire team.
<a href="/#{account.slug}/edit#canned-responses">Go ahead and create your first
canned response.</a>

**Search by tag or assignee**

Sometimes you'll come across a support request better suited for someone else
on your team. Or maybe you want to group similar conversations together and
handle them all at once. That's what tags and assignment are for. You can add
tags or assign to a team member from the response area. Once you've done that
can come back to them later by using the filtering options in the search
dropdown.  Try tagging this message and filtering from the search bar in the
top right corner.

We're always improving Helpful and adding new features. So, you'll probably
hear from me again soon with some new tips.

If you ever have a good idea for a new feature that would make your life a lot
easier, shoot me a message below.
END
  end
end
