module Klunk
  class Queue
    QUEUES = YAML.load_file('config/queues.yml').map(&:deep_symbolize_keys)
    
    class << self
      def client
        @client ||= Aws::SQS::Client.new
      end
    end
  end
end
