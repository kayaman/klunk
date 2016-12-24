require 'klunk/version'
require 'klunk/configuration'

module Klunk

  autoload :Queue
  autoload :Topic

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
      super
    end
  end
end

require 'klunk/railtie' if defined?(Rails)
