module Klunk
  class Queue < Base
    QUEUES = YAML.load_file('config/queues.yml').map(&:deep_symbolize_keys)

    class << self
      def build(queue_options)
        queue_name = queue_options.delete(:name)
        subscriptions = queue_options.delete(:subscribes)
        deadletter_queue = create_deadletter(queue_name)
        deadletter_attributes = get_attributes(deadletter_queue[:queue_url])
        attributes = build_attributes(queue_options)
        attributes[:RedrivePolicy][:deadLetterTargetArn] =
          deadletter_attributes['QueueArn']
        attributes[:RedrivePolicy] = attributes[:RedrivePolicy].to_json
        create(queue_name, attributes, subscriptions)
      end

      def create(queue_name, attributes, subscriptions)
        begin
          queue = client.create_queue(
            queue_name: name_for(queue_name),
            attributes: attributes
          )
        rescue Aws::SQS::Errors::QueueAlreadyExists
          puts "#{queue_name} already exists.".green
          queue = client.create_queue(queue_name: name_for(queue_name))
        end
        subscriptions.to_a.each do |subscription|
          topic_name = Topic.name_for(subscription[:name], subscription)
          topic = Topic.create(topic_name)
          ap Topic.subscribe(queue.queue_url, topic.topic_arn)
        end
        queue
      end

      def get_attributes(queue_url, attribute_names = ['All'])
        attributes = client.get_queue_attributes(
          queue_url: queue_url,
          attribute_names: attribute_names
        )
        attributes[:attributes]
      end

      def name_for(queue_name, deadletter = false)
        name = [Klunk.configuration.prefix, ENV['EB_ENV'], queue_name]
        name << Klunk.configuration.deadletter_suffix if deadletter
        name.compact.reject(&:blank?).join('_')
      end

      def create_deadletter(queue_name)
        client.create_queue(
          queue_name: name_for(queue_name, true),
          attributes: {
            MessageRetentionPeriod: deadletter_message_retention_period.to_s
          }
        )
      end

      def build_attributes(queue, attributes = {})
        max_receive_count = queue[:retries_limit] ||
                            Klunk.configuration.retries_limit
        message_retention_period = queue[:message_retention_period] ||
                                   Klunk.configuration.message_retention_period
        {
          MessageRetentionPeriod: message_retention_period.to_s,
          RedrivePolicy: {
            maxReceiveCount: max_receive_count
          }.merge(attributes)
        }
      end

      def queues_for_shoryuken_config
        Klunk::Queue::QUEUES.map{|queue| [name_for(queue[:name]), queue[:priority]] }
      end

      def client
        @client ||= Aws::SQS::Client.new
      end

      def resource
        Aws::SQS::Resource.new(client: client)
      end

      def deadletter_message_retention_period
        Klunk.configuration.deadletter_message_retention_period
      end
    end
  end
end
