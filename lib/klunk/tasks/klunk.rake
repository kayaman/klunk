namespace :klunk do
  namespace :sns do
    desc 'Create SNS topics'
    task create_topics: :environment do
      Klunk::Topic::TOPICS.each do |topic|
        puts Klunk::Topic.create(topic[:name])
      end
    end
  end

  namespace :sqs do
    desc 'Create SQS queues if needed'
    task create_sqs_queues_if_needed: :environment do
      # TODO: help me
    end

    desc 'Create SQS queues'
    task create_queues: :environment do
      # TODO: help me
    end
  end
end
