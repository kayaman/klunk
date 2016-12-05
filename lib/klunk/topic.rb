module Klunk
  class Topic
    TOPICS = YAML.load_file('config/topics.yml').map(&:deep_symbolize_keys)

    class << self
      def name_for(topic_name)
        [Klunk.configuration.prefix, ENV['EB_ENV'], topic_name]
          .compact.reject(&:blank?).join('_')
      end

      def create(topic_name)
        response = client.create_topic(name: name_for(topic_name))
        response.topic_arn
      end

      # def add_policy(queue, sqs_name, queue_arn, previous_policy, topic, topic_name)
      #   previous_policy ||= {
      #     'Version':  '2012-10-17',
      #     'Id': "#{queue_arn}/SQSDefaultPolicy",
      #     'Statement': [
      #       build_statement(sqs_name, queue_arn, topic_name, topic)
      #     ]
      #   }
      #   Queue.client.set_queue_attributes(
      #     queue_url: queue.queue_url,
      #     attributes: {
      #       Policy: previous_policy.tap do |p|
      #         p['Statement'] << build_statement(sqs_name, queue_arn, topic_name, topic)
      #         p['Statement'].uniq!
      #       end.to_json
      #     }
      #   )
      # end
      #
      # def build_statement(sqs_name, queue_arn, topic_name, topic)
      #   {
      #     'Sid': "#{sqs_name.camelize}_Send_#{topic_name.camelize}",
      #     'Effect': 'Allow',
      #     'Principal': { 'AWS': '*' },
      #     'Action': 'SQS:SendMessage',
      #     'Resource': queue_arn.to_s,
      #     'Condition': {
      #       'ArnEquals': { 'aws:SourceArn': topic.topic_arn.to_s }
      #     }
      #   }
      # end

      def client
        @client ||= Aws::SNS::Client.new
      end
    end
  end
end
