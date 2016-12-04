Klunk.configure  do |config|

  # Organize names by using a prefix, usually the project name
  config.prefix = Rails.application.class.parent_name.downcase if defined?(Rails)

  # Message hospital: suffix for dead letter queue names
  config.deadletter_suffix = 'failures'

  # Message hospital: maximum retries limit
  config.retries_limit = 8

end
