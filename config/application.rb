# typed: false
# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

EJSON::Rails::Railtie.ejson_secret_source = ShopifyCloud::EjsonSecrets

module FinanceHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.1)

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: ["assets", "tasks"])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Use canonical logging
    # https://github.com/Shopify/shopify-cloud/blob/main/guides/logging.md#basics
    config.shopify_cloud.logging.use_canonical_logging = true

    # Disable Raindrops middleware (because we spawn a monitor thread instead, see config/puma.rb).
    # https://github.com/shopify/shopify_metrics#spawn-raindrops-monitor-thread
    config.x.shopify_metrics_disable_raindrops_middleware = true

    config.generators.after_generate do |files|
      parsable_files = files.filter { |file| file.end_with?(".rb") }
      system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}", exception: true)
    end
  end
end
