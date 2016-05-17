config_hash = YAML.load_file("#{Rails.root.to_s}/config/config.yml")[Rails.env]
APP_CONFIG = config_hash.symbolize_keys

# Active Job
Rails.application.configure do
  config.active_job.queue_adapter = (Rails.env.sandbox? or Rails.env.production?) ? :sidekiq : :inline
end

require 'ibiza/http_persistent'
require 'ibiza/message_sender'
require 'ibiza/somebot_worker'