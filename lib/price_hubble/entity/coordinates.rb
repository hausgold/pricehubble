# frozen_string_literal: true

module PriceHubble
  # The common PriceHubble coordinates object.
  #
  # @see https://docs.pricehubble.com/#types-coordinates
  class Coordinates < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :latitude, :longitude
  end
end
