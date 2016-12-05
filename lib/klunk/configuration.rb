module Klunk
  class Configuration
    attr_accessor :prefix, :deadletter_suffix, :retries_limit,
                  :message_retention_period,
                  :deadletter_message_retention_period
  end
end
