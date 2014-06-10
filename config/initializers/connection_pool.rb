config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
config['pool']              = ENV['DB_POOL'] || 5
ActiveRecord::Base.establish_connection(config)
