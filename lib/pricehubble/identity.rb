# frozen_string_literal: true

module PriceHubble
  # Handles all the identity retrival high-level logic.
  #
  # rubocop:disable Style/ClassVars because we split module code
  module Identity
    extend ActiveSupport::Concern
    class_methods do
      # Reset the current identity.
      def reset_identity!
        @@identity = nil
      end

      # Get the current identity we use for all requests.  We try to
      # authenticate against the PriceHubble Authentication API with the
      # configured credentials from the Gem configuration.
      # (+PriceHubble.configuration+) In case this went well, we cache the
      # result. Otherwise we raise an +AuthenticationError+.
      #
      # @return [PriceHubble::Authentication] the authentication instance
      # @raise [AuthenticationError] in case of a failed login
      def identity
        # Fetch a new identity with the configured identity settings from the
        # Gem configuration
        @@identity ||= auth_by_config
        # Take care of an expired identity
        @@identity = auth_by_config if @@identity.expired?
        # Pass back the actual identity instance
        @@identity
      end

      private

      # Perform the authentication via the configured identity credentials.
      #
      # @return [Hausgold::Jwt] the new JWT instance
      # @raise [AuthenticationError] in case of a failed login
      def auth_by_config
        args = identity_params.dup
        client(:authentication).login!(**args)
      end
    end
  end
  # rubocop:enable Style/ClassVars
end
