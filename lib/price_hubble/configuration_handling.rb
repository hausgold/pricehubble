# frozen_string_literal: true

module PriceHubble
  # The top-level configuration handling.
  #
  # rubocop:disable Style/ClassVars -- because we split module code
  module ConfigurationHandling
    extend ActiveSupport::Concern

    class_methods do
      # Retrieve the current configuration object.
      #
      # @return [Configuration] the current configuration object
      def configuration
        @@configuration ||= Configuration.new
      end

      # Configure the concern by providing a block which takes
      # care of this task. Example:
      #
      #   FactoryBot::Instrumentation.configure do |conf|
      #     # conf.xyz = [..]
      #   end
      def configure
        yield(configuration)
      end

      # Reset the current configuration with the default one.
      def reset_configuration!
        @@configuration = Configuration.new
      end

      # Get back the credentials bundle for an authentication.
      #
      # @return [Hash{Symbol => String}] the identity bundle
      def identity_params
        {
          username: configuration.username,
          password: configuration.password
        }
      end

      # Retrieve the current configured logger instance.
      #
      # @return [Logger] the logger instance
      delegate :logger, to: :configuration
    end
  end
  # rubocop:enable Style/ClassVars
end
