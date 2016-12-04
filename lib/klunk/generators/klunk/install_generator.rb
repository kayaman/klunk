module Klunk
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Creates Klunk initializer for your application'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'config/initializers/klunk.rb'
        puts 'Install complete! Check \'config/initializers/klunk.rb\'.'
      end
    end
  end
end
