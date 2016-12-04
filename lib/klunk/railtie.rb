require 'rails/railtie'

module Klunk
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << Klunk

    config.after_initialize do
      unless Klunk.configured?
        warn '[Klunk] Klunk is not configured and will use the default values.\
               Use `rails generate klunk:install` and set it up.'
      end
    end

    rake_tasks do
      load "#{File.expand_path('../tasks', __FILE__)}/klunk.rake"
    end
  end
end
