# frozen_string_literal: true

module PriceHubble
  # The nested PriceHubble valuation scores object.
  #
  # @see https://docs.pricehubble.com/#international-valuation
  class ValuationScores < BaseEntity
    # Mapped and tracked attributes
    tracked_attr :quality, :condition, :location
  end
end
