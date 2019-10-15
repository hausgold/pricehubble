# frozen_string_literal: true

module PriceHubble
  # The configuration for the pricehubble gem.
  class Configuration
    include ActiveSupport::Configurable

    # Configure the API authentication credentials
    config_accessor(:username) { ENV.fetch('PRICEHUBBLE_USERNAME', nil) }
    config_accessor(:password) { ENV.fetch('PRICEHUBBLE_PASSWORD', nil) }

    # The base URL of the API (there is no staging/canary
    # endpoint we know about)
    config_accessor(:base_url) do
      val = ENV.fetch('PRICEHUBBLE_BASE_URL', 'https://api.pricehubble.com')
      val.strip.chomp('/')
    end

    # The logger instance to use (when available we use the +Rails.logger+)
    config_accessor(:logger) do
      next(Rails.logger) if defined? Rails

      Logger.new($stdout)
    end
  end
end
