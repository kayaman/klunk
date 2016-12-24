module Klunk
  class Topic

    class << self

      def topics
        if File.exists?('config/topics.yml')
          ::YAML.load_file('config/topics.yml').map(&:deep_symbolize_keys)
        else
          []
        end
      end

      def name_for(topic_name, options = {})
        system_name = options[:system] || Klunk.configuration.prefix
        [system_name, ENV['EB_ENV'], topic_name]
        .compact.reject(&:blank?).join('_')
      end

      def create(topic_name)
        topic = client.create_topic(name: name_for(topic_name))
        puts "Topic created: #{topic.topic_arn}".cyan
        topic
      end

      def publish(topic_name, message)
        topic_arn = topic_arn(topic_name)
        puts "Publishing to #{topic_arn}: #{message}"
        client.publish(topic_arn: topic_arn(topic_name), message: message)
      end

      def topic_arn(topic_name, options = {})
        "arn:aws:sns:#{ENV['AWS_REGION']}:#{ENV['AWS_ACCOUNT_ID']}:#{name_for(topic_name, options)}"
      end

      def subscribe(queue_url, topic_arn, previous_policy = nil)
        queue_attributes = Klunk::Queue.get_attributes(queue_url)
        queue_arn = queue_attributes['QueueArn']
        subscription = client.subscribe(
        topic_arn: topic_arn, protocol: 'sqs', endpoint: queue_arn
        )
        client.set_subscription_attributes(
        subscription_arn: subscription.subscription_arn,
        attribute_name: 'RawMessageDelivery', attribute_value: 'true'
        )
        if queue_attributes.key?('Policy')
          previous_policy = JSON.parse(queue_attributes['Policy'])
        end
        add_policy(queue_url, topic_arn, previous_policy)
      end

      def describe(topic_name, options = {})
        puts topic_arn(topic_name, options)
        {
          topic: topic_arn(topic_name, options),
          subscriptions: client.list_subscriptions_by_topic(
          topic_arn: topic_arn(topic_name, options)
          ).subscriptions.map { |topic| topic[:endpoint] }
        }
      end

      def add_policy(queue_url, topic_arn, previous_policy)
        previous_policy ||= build_policy(queue_url, topic_arn)
        Queue.client.set_queue_attributes(
        queue_url: queue_url,
        attributes: {
          Policy: previous_policy.tap do |p|
            (p['Statement'] ||= []) << build_statement(queue_url, topic_arn)
            p['Statement'].uniq!
          end.to_json
        }
        )
      end

      def build_statement(queue_url, topic_arn)
        queue_arn = Klunk::Queue.get_attributes(queue_url)['QueueArn']
        queue_name = queue_arn.split(':').last
        topic_name = topic_arn.split(':').last
        {
          'Sid': "#{queue_name.camelize}_Send_#{topic_name.camelize}",
          'Effect': 'Allow',
          'Principal': { 'AWS': '*' },
          'Action': 'SQS:SendMessage',
          'Resource': queue_arn,
          'Condition': {
            'ArnEquals': { 'aws:SourceArn': topic_arn }
          }
        }
      end

      def build_policy(queue_url, topic_arn)
        queue_arn = Klunk::Queue.get_attributes(queue_url)['QueueArn']
        {
          'Version':  '2012-10-17',
          'Id': "#{queue_arn}/SQSDefaultPolicy",
          'Statement': [
            build_statement(queue_url, topic_arn)
          ]
        }
      end

      def client
        @client ||= Aws::SNS::Client.new
      end
    end
  end
end
