# frozen_string_literal: true

module PriceHubble
  # The PriceHubble ecosystem is built around the authentication on each
  # request. This entity provides a simple to use interface for it.
  #
  # @see https://docs.pricehubble.com/#introduction-authentication
  class Authentication < BaseEntity
    # The expiration leeway to subtract to guarantee
    # acceptance on remote application calls
    EXPIRATION_LEEWAY = 5.minutes

    # Mapped and tracked attributes
    tracked_attr :access_token, :expires_in

    # Add some runtime attributes
    attr_reader :created_at, :expires_at

    # Register the time of initializing as base for the expiration
    after_initialize do
      @created_at = Time.current
      @expires_at = created_at + (expires_in || 1.hour.to_i) - EXPIRATION_LEEWAY
    end

    # Allow to query whenever the current authentication instance is expired or
    # not. This includes also a small leeway to ensure the acceptance is
    # guaranteed.
    #
    # @return [Boolean] whenever the authentication instance is expired or not
    def expired?
      Time.current >= expires_at
    end
  end
end
