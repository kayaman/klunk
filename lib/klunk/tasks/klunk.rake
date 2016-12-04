namespace :klunk do
  namespace :sns do
    desc "Create SNS topics"
    task create_topics: :environment do

    end
  end

  namespace :sqs do
    desc "Create SQS queues if needed"
    task create_sqs_queues_if_needed: :environment do

    end

    desc "Create SQS queues"
    task create_queues: :environment do

    end
  end
end
