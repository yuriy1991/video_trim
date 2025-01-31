# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true

    redis_host = ENV.fetch('REDIS_HOST', Rails.application.credentials.dig(:development, :redis, :host))
    redis_port = ENV.fetch('REDIS_PORT', Rails.application.credentials.dig(:development, :redis, :port))

    JWTSessions.token_store = :redis, {
      redis_host: redis_host,
      redis_port: redis_port,
      redis_db_name: '0',
      token_prefix: 'jwt_'
    }

    Sidekiq.configure_server do |config|
      config.redis = {
        url: "redis://#{redis_host}:#{redis_port}/1"
      }
    end

    Sidekiq.configure_client do |config|
      config.redis = {
        url: "redis://#{redis_host}:#{redis_port}/1"
      }
    end
  end
end
