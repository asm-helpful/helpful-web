require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID
  after_save :update_search_index
  belongs_to :conversation, touch: true
  belongs_to :person
  
  private
    def update_search_index
      if ENV['ELASTICSEARCH_URL']
        es = Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
        es.index( { index: 'helpful', type:  'message', id: self.id, body: { content: self.content} } )
      end
    end
end
