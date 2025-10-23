# frozen_string_literal: true

module PriceHubble
  # The configuration for the pricehubble gem.
  class Configuration < ActiveSupport::OrderedOptions
    # Track our configurations settings (+Symbol+ keys) and their defaults as
    # lazy-loaded +Proc+'s values
    class_attribute :defaults,
                    instance_reader: true,
                    instance_writer: false,
                    instance_predicate: false,
                    default: {}

    # Create a new +Configuration+ instance with all settings populated with
    # their respective defaults.
    #
    # @param args [Hash{Symbol => Mixed}] additional settings which
    #   overwrite the defaults
    # @return [Configuration] the new configuration instance
    def initialize(**args)
      super()
      defaults.each { |key, default| self[key] = instance_exec(&default) }
      merge!(**args)
    end

    # A simple DSL method to define new configuration accessors/settings with
    # their defaults. The defaults can be retrieved with
    # +Configuration.defaults+ or +Configuration.new.defaults+.
    #
    # @param name [Symbol, String] the name of the configuration
    #   accessor/setting
    # @param default [Mixed, nil] a non-lazy-loaded static value, serving as a
    #   default value for the setting
    # @param block [Proc] when given, the default value will be lazy-loaded
    #   (result of the Proc)
    def self.config_accessor(name, default = nil, &block)
      # Save the given configuration accessor default value
      defaults[name.to_sym] = block || -> { default }

      # Compile reader/writer methods so we don't have to go through
      # +ActiveSupport::OrderedOptions#method_missing+.
      define_method(name) { self[name] }
      define_method("#{name}=") { |value| self[name] = value }
    end

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

    # Enable request logging or not
    config_accessor(:request_logging) { true }
  end
end
