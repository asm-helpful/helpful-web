# Wraps up the information about the person sending a message and provides
# helper methods for creating a new message.
class MessageAuthor
  def initialize(account, email)
    @account = account
    @email = email
  end

  # Public: Creates a new message as a part of the conversation with the
  # content passed in. The author of the message is found based on the account
  # and email passed in when initializing the object.
  #
  # Returns a Message.
  def compose_message(conversation, content)
    Message.new(
      conversation: conversation,
      content: content,
      person: person_with_updated_name
    )
  end

  # Public: Finds the relavant person and updates their name based on the email
  # address.
  #
  # Returns a Person.
  def person_with_updated_name
    person { |p| p.name = email_display_name }
  end

  # Public: Finds the person associated with the account and email address.
  #
  # Returns a Person.
  def person(&block)
    people.find_or_create_by(email: email_address, &block)
  end

  def email_address
    @email.address
  end

  def email_display_name
    @email.display_name
  end

  def people
    @account.people
  end
end
