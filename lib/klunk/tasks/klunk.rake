namespace :klunk do
  namespace :sns do
    desc "'Create SNS topics'"
    task create_topics: :environment do
      # TODO: help me
      puts "yo"
    end
  end

  namespace :sqs do
    desc 'Create SQS queues if needed'
    task create_sqs_queues_if_needed: :environment do
      # TODO: help me
      puts "yo"
    end

    desc 'Create SQS queues'
    task create_queues: :environment do
      # TODO: help me
      puts "yo"
    end
  end
end
