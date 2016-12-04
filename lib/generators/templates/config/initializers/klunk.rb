Klunk.configure  do |config|

  config.prefix = Rails.application.class.parent_name.downcase if defined?(Rails)

end
