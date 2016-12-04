require 'klunk/version'
require 'klunk/configuration'
require 'klunk/queue'
require 'klunk/topic'

module Klunk
  class << self
    attr_accessor :configuration
  end

  @@configured = false

  def self.configured? #:nodoc:
    @@configured
  end

  def self.configure
    @@configured = true
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

require 'klunk/railtie' if defined?(Rails)
