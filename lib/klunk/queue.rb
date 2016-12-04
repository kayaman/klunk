module Klunk
  class Queue
    def client
      @client ||= Aws::SQS::Client.new
    end
  end
end
