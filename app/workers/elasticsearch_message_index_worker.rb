class ElasticsearchMessageIndexWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find_by_id(message_id)
    raise "No message exists with uuid #{message_id}" unless message
    message.update_search_index
  end
end
