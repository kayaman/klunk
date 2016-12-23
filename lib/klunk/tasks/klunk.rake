namespace :klunk do

  desc 'Bootstrap whole structure'
  task bootstrap: :environment do
    puts 'Bootstraping topics:'
    Rake::Task['klunk:sns:create_topics'].invoke
    puts 'Bootstraping queues:'
    Rake::Task['klunk:sqs:create_queues_if_needed'].invoke
    puts 'Current structure:'
    Rake::Task['klunk:describe'].invoke
  end

  desc 'Describe current structure'
  task describe: :environment do
    Klunk::Topic::TOPICS.each do |topic|
      ap Klunk::Topic.describe(topic[:name])
    end
    Klunk::Queue::QUEUES.each do |queue|
      queue[:subscribes].to_a.each do |topic_options|
        topic_name = topic_options.delete(:name)
        ap Klunk::Topic.describe(topic_name, topic_options)
      end
    end
  end

  namespace :sns do
    desc 'Create SNS topics'
    task create_topics: :environment do
      Klunk::Topic::TOPICS.each do |topic|
        Klunk::Topic.create(topic[:name])
      end
    end
  end

  namespace :sqs do
    desc 'Create SQS queues if needed'
    task create_queues_if_needed: :environment do
      existing_queues = Klunk::Queue.client.list_queues(queue_name_prefix: Klunk::Queue.name_for('')).queue_urls.collect{|queue| queue.split('/').last }
      needed_queues = Klunk::Queue::QUEUES.map do |queue|
        [Klunk::Queue.name_for(queue[:name]), Klunk::Queue.name_for(queue[:name], true)]
      end.flatten
      unless (needed_queues - existing_queues).empty?
        Rake::Task["klunk:sqs:create_queues"].invoke
      else
        puts "\tQueues were set up. Skipping..."
      end
    end

    desc 'Create SQS queues'
    task create_queues: :environment do
      Klunk::Queue::QUEUES.each do |queue|
        q = Klunk::Queue.build(queue)
        puts "\n#{q[:queue_url]}"
      end
    end
  end
end
