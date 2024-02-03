Statsly::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  #  Performance / environment settings
  config.cache_classes = true
  config.whiny_nils = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  #  ActiveRecord
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = true
  config.assets.debug = false

  #  Enable log shortening
  config.lograge.enabled = true

end
