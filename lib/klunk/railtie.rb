require 'rails/railtie'

module Klunk
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << Klunk

    config.after_initialize do
      unless Klunk.configured?
        warn '[Klunk] Klunk is not configured in the application and will use the default values.' +
          ' Use `rails generate klunk:install` to generate the Klunk configuration.'
      end
    end

    rake_tasks do

      load "#{File.expand_path('../tasks', __FILE__)}/klunk.rake"
    end
  end
end
