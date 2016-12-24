require 'klunk/version'
require 'klunk/configuration'
require 'klunk/base'
require 'klunk/queue'
require 'klunk/topic'

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
  end
end

require 'klunk/railtie' if defined?(Rails)
