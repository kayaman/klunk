require 'klunk/version'
require 'klunk/configuration'
require 'klunk/topic'
require 'klunk/queue'

module Klunk
  class << self
    attr_accessor :configuration, :configured

    def configure
      self.configured = true
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def configured?
      configured
    end

    def eager_load!
      #wtf
    end
  end
end

require 'klunk/railtie' if defined?(Rails)
require 'klunk/rake_tasks'
