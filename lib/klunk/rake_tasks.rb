require 'rake'

module Klunk
  class RakeTasks
    include Rake::DSL if defined?(Rake::DSL)

    def install_tasks
      load 'klunk/tasks/klunk.rake'
    end
  end
end

Klunk::RakeTasks.new.install_tasks
