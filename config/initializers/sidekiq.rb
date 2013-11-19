require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1, :namespace => 'helpful' }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 9, :namespace => 'helpful' }
end
