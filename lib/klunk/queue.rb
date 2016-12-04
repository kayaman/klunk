module Klunk
  class Queue

    def sqs
      @sqs ||= Aws::SQS::Client.new
    end

  end
end
