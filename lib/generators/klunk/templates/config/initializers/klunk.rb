Klunk.configure do |config|
  # Organize names by using a prefix, usually the project name
  config.prefix = Rails.application.class.parent_name.downcase if defined? Rails

  # Message hospital: suffix for dead letter queue names
  config.deadletter_suffix = 'failures'

  # Message hospital: maximum retries limit
  config.retries_limit = 8

  # The number of seconds for which Amazon SQS retains a message. An integer
  # representing seconds, from 60 (1 minute) to 120,9600 (14 days).
  # The default is 345,600 (4 days).
  config.message_retention_period = 345_600

  config.deadletter_message_retention_period = 1_209_600
end
