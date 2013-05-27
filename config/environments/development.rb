Saintstir::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  config.log_level = :debug

  config.consider_all_requests_local       = true

  # Cache settings
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store


  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    :port           => 587,
    :address        => 'smtp.mailgun.org',
    :user_name      => 'postmaster@app2912649.mailgun.org',
    :password       => '73c3j-42aow9',
    :domain         => 'saintstir-staging.herokuapp.com',
    :authentication => :plain
  }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Do not compress assets
  config.assets.compress = false
  config.assets.debug = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
