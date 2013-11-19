require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1, :namespace => 'helpful' }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 9, :namespace => 'helpful' }
end

# change the default log format to make it more friendly to STDOUT logging
module Sidekiq
  module Logging
    class Pretty
      def call(severity, time, program_name, message)
        # heroku doesn't need timestamp and process id, strip em out!
        "TID-#{Thread.current.object_id.to_s(36)}#{context} #{severity}: #{message}\n"
      end
    end
  end
end