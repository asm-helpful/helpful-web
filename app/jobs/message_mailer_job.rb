class MessageMailerJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    result = MessageMailer.deliver(message)
    # message._id = result.id
    # Do something later
  end
end
