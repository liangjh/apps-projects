Saintstir::Application.configure do

  config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
  Rails.logger.info("loading lib paths: #{config.autoload_paths}")

end
