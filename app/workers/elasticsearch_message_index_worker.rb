class ElasticsearchMessageIndexWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find_by(id: message_id)
    raise "No message exists with uuid #{message_id}" unless message
    message.__elasticsearch__.index_document
  end
end
